# cs-w4111-project

Database Project replicating a Transaction Processing Company

* The PostgreSQL account name is hb2779.

* URL: 

* Alignment with Objectives Proposed in Part 1 of the Project:

- Implemented features directly align with the project's objective of creating a simplified payment processing database system.
- Successfully developed and integrated all planned components as outlined in the initial proposal.
- These components offer insights into card transactions, shedding light on the intricate processes behind digital fund flow.

All proposed elements were successfully implemented, providing a comprehensive understanding of modern finance mechanisms and technology.

* Two Pages that Involve the Most Interesting Database Operations:

1. Search Transactions for a Cardholder

Purpose: This page facilitates the search for transaction details associated with a specific cardholder.

- User Input: The email entered is used to retrieve cardholder information from the database.

- Database Query: The application performs queries based on the entered email to fetch cardholder details and associated transactions from the database.

- Display of Transactions: Transaction data is dynamically populated in a table based on the fetched data, involving operations to retrieve and display transaction records.

2. Client Analytics: 

Purpose: This page generates analytical charts based on transaction data for client insights.

- Chart Selection: User selection of chart types initiates queries to the database for specific transaction data (fraud percentage, success percentage, average transactions, peak transaction times, cross-border transactions).

- Data Fetching: Upon selecting a chart type, the application fetches relevant data from the database.

- Chart Rendering: The retrieved data is processed and rendered using Chart.js to display meaningful analytics, requiring operations to aggregate and format transaction information.

These pages showcase intriguing database interactions, involving data retrieval, query executions, and dynamic rendering based on user inputs, enabling users to explore transaction details and derive insights through analytics.
