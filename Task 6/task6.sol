// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GradeBook {
    //creating strucure
    struct Grade {
        string studentName;
        string subject;
        uint8 grade;
    }

    //creating grade array
    Grade[] public grades;

    //owner
    address public owner;

    //modifier
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    //constructor for setting owner
    constructor() {
        owner = msg.sender;
    }

    //function for adding grades
    function addGrade(
        string memory _studentName,
        string memory _subject,
        uint8 _grade
    ) public {
        grades.push(Grade(_studentName, _subject, _grade));
    }
    //function for upgrade
    function updateGrade(
        string memory _studentName,
        string memory _subject,
        uint8 _grade
    ) public onlyOwner {
        //    comparing string directly with '=='operator is not posible so we need to compare hash of two strings

        for (uint i = 0; i < grades.length; i++) {
            if (
                keccak256(abi.encodePacked(grades[i].studentName)) ==
                keccak256(abi.encodePacked(_studentName)) &&
                keccak256(abi.encodePacked(grades[i].subject)) ==
                keccak256(abi.encodePacked(_subject))
            ) {
                grades[i].grade = _grade;
                return;
            }
        }
        revert("Grade not found for the student and subject");
    }

    //function for getting grades
    function getGrade(
        string memory _studentName,
        string memory _subject
    ) public view returns (uint8) {
        for (uint i = 0; i < grades.length; i++) {
            if (
                keccak256(abi.encodePacked(grades[i].studentName)) ==
                keccak256(abi.encodePacked(_studentName)) &&
                keccak256(abi.encodePacked(grades[i].subject)) ==
                keccak256(abi.encodePacked(_subject))
            ) {
                return grades[i].grade;
            }
        }
        revert("Grade not found for the student and subject");
    }

    //functio for averagegrades
    function averageGrade(string memory _subject) public view returns (uint) {
        uint total = 0;
        uint count = 0;
        for (uint i = 0; i < grades.length; i++) {
            if (
                keccak256(abi.encodePacked(grades[i].subject)) ==
                keccak256(abi.encodePacked(_subject))
            ) {
                total += grades[i].grade;
                count++;
            }
        }
        require(count > 0, "No grades found for the subject");
        return total / count;
    }
}
