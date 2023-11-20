# cs-w4111-project

Database Project replicating a Transaction Processing Company. 

* Interactions 

The projects has two access points: 

1. Url with just / - Back-end access for employees of the transaction processing company (Y)
2. Url with /internetflix - Access to customers. Internetlfix offers a streamlined payment system with three payment options for users. Upon login/signup, users select their country and preferred plan for payment.

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

- Database Query: The application performs queries based on the entered email to fetch cardholder details and associated transactions from the database. Enter a cardholder’s email and get all the cards associated with the user, their balances and their lifetime transactions. 

- Display of Transactions: Transaction data is dynamically populated in a table based on the fetched data, involving operations to retrieve and display transaction records. Can use dropdowns to filter by merchant, card, or approved/not approved.

2. Client Analytics: 

Purpose: This page generates analytical charts based on transaction data for client insights. Can see transactions based on 5 KPIs and can help banks/merchants increase their revenue.

- Chart Selection: User selection of chart types initiates queries to the database for specific transaction data (fraud percentage, success percentage, average transactions, peak transaction times, cross-border transactions).

- Data Fetching: Upon selecting a chart type, the application fetches relevant data from the database.

- Chart Rendering: The retrieved data is processed and rendered using Chart.js to display meaningful analytics, requiring operations to aggregate and format transaction information.

These pages showcase intriguing database interactions, involving data retrieval, query executions, and dynamic rendering based on user inputs, enabling users to explore transaction details and derive insights through analytics.

* Use of AI Tools in the Project

We have used ChatGPT for refining and optimizing our CSS code, elevating the visual appeal and user experience of our webpages.
