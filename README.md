# Project Y

Database Project replicating a Transaction Processing Company. 

* Interactions 

The projects has two access points: 

1. Url with just / - Back-end access for employees of the transaction processing company (Y)
2. Url with /internetflix - Access to customers. Internetlfix offers a streamlined payment system with three payment options for users. Upon login/signup, users select their country and preferred plan for payment.

* The PostgreSQL account name is hb2779.

* URL: 

* Alignment with Objectives Proposed in Part 1 of the Project:

  - Implemented features directly aligned with the project's objective of creating a simplified payment processing database system.
  - Successfully developed and integrated all planned components as outlined in the initial proposal.
  - These components offer insights into card transactions, shedding light on the intricate processes behind digital fund flow.

All proposed elements were successfully implemented, providing a comprehensive understanding of modern finance mechanisms and technology.

* Pages that Involve the Most Interesting Database Operations:

1. Pay at a Merchant

Purpose: This page shows how users/cardholders can make online payments.

- User Input: The user logs in/ signs up to the web application (where they are authenticated using the database records) and proceeds to make a payment

- Payment types: The user has the option to select which country they want to make the payment for and has three subscription options to choose from - Weekly, Monthly, and Annual. There are three payment modes - Pay by existing card token, create a new token and pay, and pay by card. The best part? Eligible cardholders get discount and we maintain the record of eligible cardholders and process transactions with discounts automatically
  
- Database Query: The payment process is quite complex and uses multiple functions and stored procedures that we wrote. Every transaction goes through five rounds of checks before a transaction is approved -
  1. Has the card expired?
  2. Is CVV correct?
  3. Check if the card exists for that email, card number, CVV, and Expiry Date
  4. Check if the amount <= available funds
  5. Is the transaction happening in the same country as the card was issued?
 
 Once all the checks have passed, the transaction is approved, else, the reason for failure can be seen in the below webpage

2. Search Transactions for a Cardholder

Purpose: This page facilitates the search for transaction details associated with a specific cardholder.

- User Input: The email entered is used to retrieve cardholder information from the database.

- Database Query: The application performs queries based on the entered email to fetch cardholder details and associated transactions from the database. Enter a cardholder’s email and get all the cards associated with the user, their balances and their lifetime transactions. 

- Display of Transactions: Transaction data is dynamically populated in a table based on the fetched data, involving operations to retrieve and display transaction records. Can use dropdowns to filter by merchant, card, or approved/not approved.

3. Client Analytics: 

Purpose: This page generates analytical charts based on transaction data for client insights. Can see transactions based on 5 KPIs and can help banks/merchants increase their revenue.

- Chart Selection: User selection of chart types initiates queries to the database for specific transaction data (fraud percentage, success percentage, average transactions, peak transaction times, cross-border transactions).

- Data Fetching: Upon selecting a chart type, the application fetches relevant data from the database.

- Chart Rendering: The retrieved data is processed and rendered using Chart.js to display meaningful analytics, requiring operations to aggregate and format transaction information.

These pages showcase intriguing database interactions, involving data retrieval, query executions, and dynamic rendering based on user inputs, enabling users to explore transaction details and derive insights through analytics.

* Use of AI Tools in the Project

We have used ChatGPT for refining and optimizing our CSS code, elevating the visual appeal and user experience of our webpages.
