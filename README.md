# Prescription Management Database

A Computer Science capstone project designed to improve prescription tracking and give consumers greater access to information about prescription costs, insurance coverage, and available medication choices.

## Project Overview

I developed this project to address two challenges related to prescription management: tracking the progress of a prescription and helping consumers better understand their prescription options.

The first goal was to allow a prescription to be tracked from the doctor to the pharmacy and ultimately to the customer through three statuses: **Received, In Process, and Complete**.

The second goal was to give consumers more knowledge about their prescriptions. The database was designed to provide information about **cost, insurance coverage, and available medication choices**, helping users better understand their options and identify more affordable alternatives when available.

The project was motivated by challenges within the U.S. healthcare system, particularly high prescription costs and the difficulty consumers may have understanding the options available to them.

## Project Goals

### Prescription Tracking
- Track prescriptions from the doctor to the pharmacy to the user
- Provide prescription status information
- Track three primary statuses: **Received, In Process, and Complete**

### The Power of Knowledge
- Provide consumers with prescription cost information
- Show relevant insurance information and coverage
- Provide information about available medication choices
- Help consumers identify more affordable alternatives when available
- Give users more information to help them understand their prescription options

## Technologies Used

- PostgreSQL
- SQL
- Python
- Flask
- SQLAlchemy
- HTML

## Project Components

The following files document the development of the project from initial requirements and database design through implementation, analysis, and presentation.

1. **[User Data Requirements](User%20Data%20Requirements.docx)**  
   Defines the user requirements, data requirements, and relationships that guided the database design.

2. **[ER Diagram](Capstone%20Project%20ER%20Diagram.pdf)**  
   Visualizes the entities, attributes, and relationships within the prescription management system.

3. **[Relational Schema](Capstone%20Relational%20Schema.pdf)**  
   Shows the relational structure of the database, including tables, primary keys, and foreign key relationships.

4. **[SQL Database Implementation](CapstoneSQL1.sql)**  
   Contains the SQL used to create and populate the PostgreSQL database.

5. **[Queries and Examples](Copy%20of%20Queries%20and%20Examples.docx)**  
   Demonstrates SQL queries developed to retrieve and analyze prescription, pharmacy, insurance, medication, and user information.

6. **[Database and User Interface Connection](Connecting%20Database%20and%20UI%20using%20SQLAlchemy.docx)**  
   Documents the work completed using Flask and SQLAlchemy to connect the database with a user interface.

7. **[Capstone Presentation](Tracking%20Prescriptions%20DatabasePowerPoint.pptx)**  
   Provides an overview of the project's purpose, goals, development process, challenges, and results.
