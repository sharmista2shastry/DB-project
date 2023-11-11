
"""
Columbia's COMS W4111.001 Introduction to Databases
Example Webserver
To run locally:
    python3 server.py
Go to http://localhost:8111 in your browser.
A debugger such as "pdb" may be helpful for debugging.
Read about it online.
"""
import os
import sys
  # accessible as a variable in index.html:
from sqlalchemy import *
from sqlalchemy.pool import NullPool
from flask import Flask, request, render_template, g, redirect, Response, abort, jsonify, url_for

tmpl_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'templates')
app = Flask(__name__, template_folder=tmpl_dir)


#
# The following is a dummy URI that does not connect to a valid database. You will need to modify it to connect to your Part 2 database in order to use the data.
#
# XXX: The URI should be in the format of:
#
#     postgresql://USER:PASSWORD@34.75.94.195/proj1part2
#
# For example, if you had username gravano and password foobar, then the following line would be:
#
#     DATABASEURI = "postgresql://gravano:foobar@34.75.94.195/proj1part2"
#
DATABASEURI = "postgresql://hb2779:510211@34.74.171.121/proj1part2"


#
# This line creates a database engine that knows how to connect to the URI above.
#
engine = create_engine(DATABASEURI)

#
# Example of running queries in your database
# Note that this will probably not work if you already have a table named 'test' in your database, containing meaningful data. This is only an example showing you how to run queries in your database using SQLAlchemy.
#
conn = engine.connect()

# The string needs to be wrapped around text()

# conn.execute(text("""CREATE TABLE IF NOT EXISTS test (
#   id serial,
#   name text
# );"""))
# conn.execute(text("""INSERT INTO test(name) VALUES ('grace hopper'), ('alan turing'), ('ada lovelace');"""))

# To make the queries run, we need to add this commit line

conn.commit() 

@app.before_request
def before_request():
  """
  This function is run at the beginning of every web request
  (every time you enter an address in the web browser).
  We use it to setup a database connection that can be used throughout the request.

  The variable g is globally accessible.
  """
  try:
    g.conn = engine.connect()
  except:
    print("uh oh, problem connecting to database")
    import traceback; traceback.print_exc()
    g.conn = None

@app.teardown_request
def teardown_request(exception):
  """
  At the end of the web request, this makes sure to close the database connection.
  If you don't, the database could run out of memory!
  """
  try:
    g.conn.close()
  except Exception as e:
    pass


#
# @app.route is a decorator around index() that means:
#   run index() whenever the user tries to access the "/" path using a GET request
#
# If you wanted the user to go to, for example, localhost:8111/foobar/ with POST or GET then you could use:
#
#       @app.route("/foobar/", methods=["POST", "GET"])
#
# PROTIP: (the trailing / in the path is important)
#
# see for routing: https://flask.palletsprojects.com/en/2.0.x/quickstart/?highlight=routing
# see for decorators: http://simeonfranklin.com/blog/2012/jul/1/python-decorators-in-12-steps/
#

@app.route('/')
def index():
  """
  request is a special object that Flask provides to access web request information:

  request.method:   "GET" or "POST"
  request.form:     if the browser submitted a form, this contains the data in the form
  request.args:     dictionary of URL arguments, e.g., {a:1, b:2} for http://localhost?a=1&b=2

  See its API: https://flask.palletsprojects.com/en/2.0.x/api/?highlight=incoming%20request%20data

  """

  # DEBUG: this is debugging code to see what request looks like
  print(request.args)

  #
  # example of a database query 
  #
  cursor = g.conn.execute(text("SELECT name FROM test"))
  g.conn.commit()

  # 2 ways to get results

  # Indexing result by column number
  names = []
  for result in cursor:
    # print(result[0])
    names.append(result[0])  

  # Indexing result by column name
  # names = []
  # results = cursor.fetchall()
  # print()
  # for result in results:
  #   print(result["name"])
  #   names.append(result["name"])
  cursor.close()

  #
  # Flask uses Jinja templates, which is an extension to HTML where you can
  # pass data to a template and dynamically generate HTML based on the data
  # (you can think of it as simple PHP)
  # documentation: https://realpython.com/primer-on-jinja-templating/
  #
  # You can see an example template in templates/index.html
  #
  # context are the variables that are passed to the template.
  # for example, "data" key in the context variable defined below will be
  # accessible as a variable in index.html:
  #
  #     # will te: [u'grace hopper', u'alan turing', u'ada lovelace']
  #     <div>{{data}}</div>
  #
  #     # creates a <div> tag for each element in data
  #     # will print:
  #     #
  #     #   <div>grace hopper</div>
  #     #   <div>alan turing</div>
  #     #   <div>ada lovelace</div>
  #     #
  #     {% for n in data %}
  #     <div>{{n}}</div>
  #     {% endfor %}
  #
  context = dict(data = names)


  #
  # render_template looks in the templates/ folder for files.
  # for example, the below file reads template/index.html
  #

  return render_template("transactionhelper.html")

ADMIN_USERNAME = "admin"
ADMIN_PASSWORD = "adminpassword"

@app.route('/baselogin', methods=['POST'])
def baselogin():
    email = request.json['email']
    password = request.json['password']

    if email == ADMIN_USERNAME and password == ADMIN_PASSWORD:
        response = {"output": True}
    else:
        response = {"output": False}

    response = {str(key): value for key, value in response.items()}
    return jsonify(result=response)

#
# This is an example of a different path.  You can see it at:
#
#     localhost:8111/another
#
# Notice that the function name is another() rather than index()
# The functions for each app.route need to have different names
#
@app.route('/internetflix')
def internetflix():
  return render_template("internetflix.html")


# Example of adding new data to the database
@app.route('/add', methods=['POST'])
def add():
  name = request.form['name']
  params_dict = {"name":name}
  g.conn.execute(text('INSERT INTO test(name) VALUES (:name)'), params_dict)
  g.conn.commit()
  return redirect('/')

@app.route('/gettransactions', methods=['GET','POST'])
def gettransactions():
    # print(request.data)
    # print(request.args)
    # print(request.values)
    # print(request.get_json())
    email = request.json['email']
    merchantName = request.json['merchantSelected']
    cardNumber = request.json['cardNumber']
    transactionStatus = request.json['transactionStatus']
    print(request.json)
    queryStringAppend = 'WHERE '
    flag = False
    if len(merchantName) > 0 and merchantName!='All Merchants':
       queryStringAppend += 'MERCHANT_NAME = (:merchantName)'
       flag = True
    if len(cardNumber) > 0 and cardNumber!='All Cards':
      if flag:
          queryStringAppend += ' AND CARD_NUMBER = (:cardNumber)'
      else:
         queryStringAppend += 'CARD_NUMBER = (:cardNumber)'
         flag = True
    if len(transactionStatus) > 0 and transactionStatus!='all':
      if flag:
          queryStringAppend += ' AND TRANSACTION_STATUS = (:transactionStatus)'
      else:
         queryStringAppend += 'TRANSACTION_STATUS = (:transactionStatus)'
    params_dict = {"email":email, "merchantName":merchantName,'cardNumber':cardNumber,'transactionStatus':transactionStatus}
    if queryStringAppend != 'WHERE ':
      cursor = g.conn.execute(text("SELECT * FROM GET_TRANSACTIONS_BY_EMAIL(:email) "+queryStringAppend), params_dict)
      g.conn.commit()
    else:
      cursor = g.conn.execute(text("SELECT * FROM GET_TRANSACTIONS_BY_EMAIL(:email)"), params_dict)
      g.conn.commit()

    complete_results = []
    for result in cursor:
      complete_results.append({
        "transaction_id": result[0],
        "transaction_amount": float(result[1]) if result[1] is not None else float(0),
        "transaction_currency": result[2],
        "transaction_fraud": result[3],
        "transaction_timestamp": result[4],
        "merchant": result[14],
        "acquirer_id": result[6],
        "transaction_type": result[13],
        "decline_reason_id": result[8],
        "authentication_type": result[12],
        "card_number": result[10],
        "cardholder_id": result[11],
        "transaction_status": result[15],
        "decline_reason": result[16]
      })
    cursor.close()
    result = {
        "output": complete_results
    }
    result = {str(key): value for key, value in result.items()}
    return jsonify(result=result)


@app.route('/login', methods=['GET','POST'])
def login():
    email = request.json['email']
    password = request.json['password']
    params_dict = {"email":email, "password":password}
    cursor = g.conn.execute(text("SELECT 1 FROM INTERNETFLIX_CUSTOMER_DATA WHERE CUSTOMER_EMAIL=(:email) AND PASS_WORD=(:password)"), params_dict)
    g.conn.commit()

    isValid = False
    for result in cursor:
        if result[0] == 1:
            isValid = True
    cursor.close()
    response = {
        "output": isValid
    }
    response = {str(key): value for key, value in response.items()}
    return jsonify(result=response)

@app.route('/getmerchants', methods=['GET','POST'])
def getmerchants():
    cursor = g.conn.execute(text("SELECT DISTINCT(MERCHANT_NAME) FROM MERCHANTS;"))
    g.conn.commit()

    merchant_list = []
    for result in cursor:
        merchant_list.append(result[0])
    cursor.close()
    response = {
        "merchant_list": merchant_list
    }
    response = {str(key): value for key, value in response.items()}
    return jsonify(result=response)

@app.route('/getcards', methods=['GET','POST'])
def getcards():
    email = request.json['email']
    params_dict = {"email":email}
    cursor = g.conn.execute(text("SELECT DISTINCT(CARD_NUMBER) FROM CARDS C JOIN CARDHOLDER_DETAILS CD ON C.CARDHOLDER_ID = CD.CARDHOLDER_ID WHERE CD.EMAIL=(:email);"), params_dict)
    g.conn.commit()

    merchant_list = []
    for result in cursor:
        merchant_list.append(result[0])
    cursor.close()
    response = {
        "cards": merchant_list
    }
    response = {str(key): value for key, value in response.items()}
    return jsonify(result=response)

@app.route('/getname', methods=['GET','POST'])
def getname():
    email = request.json['email']
    params_dict = {"email":email}
    cursor = g.conn.execute(text("SELECT CUSTOMER_NAME FROM INTERNETFLIX_CUSTOMER_DATA WHERE CUSTOMER_EMAIL=(:email);"), params_dict)
    g.conn.commit()

    name = ''
    for result in cursor:
        name =result[0]

    cursor.close()

    response = {
        "name": name
    }

    response = {str(key): value for key, value in response.items()}
    return jsonify(result=response)

@app.route('/getCardholderDetails', methods=['GET','POST'])
def getCardholderDetails():
    email = request.json['email']
    params_dict = {"email":email}
    cursor = g.conn.execute(text("SELECT CARDHOLDER_NAME, CARDHOLDER_ID FROM CARDHOLDER_DETAILS WHERE EMAIL=(:email);"), params_dict)
    g.conn.commit()

    name = ''
    cardholder_id = 0
    for result in cursor:
        name =result[0]
        cardholder_id = result[1]
    params_dict = {"cardholder_id":cardholder_id}
    cursor = g.conn.execute(text("SELECT CARD_NUMBER, AVAILABLE_FUNDS FROM CARDS WHERE CARDHOLDER_ID=(:cardholder_id);"), params_dict)
    g.conn.commit()

    name = ''
    for result in cursor:
        name =result[0]

    cursor.close()

    response = {
        "name": name,
        "card_list"
    }

    response = {str(key): value for key, value in response.items()}
    return jsonify(result=response)

@app.route('/signup', methods=['GET','POST'])
def signup():
    email = request.json['email']
    name = request.json['name']
    address = request.json['address']
    password = request.json['password']
    params_dict = {"email":email, "password":password, "name":name, "address":address}
    isValid = False
    try:
      cursor = g.conn.execute(text("INSERT INTO INTERNETFLIX_CUSTOMER_DATA(CUSTOMER_NAME, CUSTOMER_ADDRESS, CUSTOMER_EMAIL, PASS_WORD) VALUES (:name, :address, :email, :password);"), params_dict)

   # Check if the insert was successful
      isValid = cursor.rowcount > 0

      g.conn.commit()

    # Close the cursor
      cursor.close()
    except:
       isValid = False
    response = {
        "output": isValid
    }
    response = {str(key): value for key, value in response.items()}
    return jsonify(result=response)

@app.route('/checkexistingtoken', methods=['GET','POST'])
def checkexistingtoken():
    email = request.json['email']
    country = request.json['country']
    params_dict = {"email":email, "country":country}
    doesExist = False
    try:
      cursor = g.conn.execute(text("SELECT S.CARD_TOKEN FROM internetflix_stored_card_data S WHERE S.STORED_CARD_ID = (SELECT A.STORED_CARD_ID FROM INTERNETFLIX_CUSTOMER_DATA A WHERE A.CUSTOMER_EMAIL=(:email)) AND S.MERCHANT_ID=(SELECT M.MERCHANT_ID FROM MERCHANTS M WHERE M.MERCHANT_NAME ILIKE 'internetflix ltd.' AND M.COUNTRY_ID=(SELECT C.COUNTRY_ID FROM COUNTRIES C WHERE C.COUNTRY=(:country)));"), params_dict)
            
      for result in cursor:
          doesExist = True
    
      g.conn.commit()

    # Close the cursor
      cursor.close()
    except Exception as error:
       print('Exception',error)
    response = {
        "doesExist": doesExist,
    }
    response = {str(key): value for key, value in response.items()}
    return jsonify(result=response)

@app.route('/paywithtoken', methods=['GET','POST'])
def paywithtoken():
    email = request.json['email']
    country = request.json['country']
    amount = request.json['amount']
    params_dict = {"email":email, "country":country}
    isValid = False
    isSuccess = False

    try:
      cursor = g.conn.execute(text("SELECT S.CARD_TOKEN FROM internetflix_stored_card_data S WHERE S.STORED_CARD_ID = (SELECT A.STORED_CARD_ID FROM INTERNETFLIX_CUSTOMER_DATA A WHERE A.CUSTOMER_EMAIL=(:email)) AND S.MERCHANT_ID=(SELECT M.MERCHANT_ID FROM MERCHANTS M WHERE M.MERCHANT_NAME ILIKE 'internetflix ltd.' AND M.COUNTRY_ID=(SELECT C.COUNTRY_ID FROM COUNTRIES C WHERE C.COUNTRY=(:country)));"), params_dict)
      
      card_token = ''
      
      for result in cursor:
         card_token = result[0]

      params_dict = {"token":card_token}
      cursor = g.conn.execute(text("SELECT * FROM DECRYPTTOKEN(:token);"), params_dict)

      merchant_id = ''
      card_number = ''
      token_creation_date = ''

      for result in cursor:
         merchant_id = result[0]
         card_number = result[1]
         token_creation_date = result[2]

      # print(card_number)
      # print(token_creation_date)
      params_dict = {"dater":token_creation_date}
      
      # print('Hola1')
      cursor = g.conn.execute(text("SELECT EXTRACT(MONTH FROM age((:dater)::date, current_date)) < 6;"), params_dict)
      # print('Hola2')
      for result in cursor:
        #  print(result[0])
         if result[0]==True:
          isValid = True
      # print(isValid)
      if isValid:
        # print('running process transaction now')
        params_dict = {"email":email,"card_number":card_number,"amount":amount,"merchant_id":merchant_id,"transaction_id":1}
        cursor = g.conn.execute(text("SELECT PROCESS_TRANSACTION(:email, :card_number, :amount, :merchant_id, :transaction_id);"), params_dict)

        for result in cursor:
          if result[0]==True:
             isSuccess = True

      g.conn.commit()

    # Close the cursor
      cursor.close()
    except Exception as error:
       print('Exception',error)
       isValid = False
    response = {
        "isValid": isValid,
        "transaction": isSuccess
    }
    response = {str(key): value for key, value in response.items()}
    return jsonify(result=response)

@app.route('/paywithcard', methods=['GET','POST'])
def paywithcard():
    email = request.json['email']
    country = request.json['country']
    amount = request.json['amount']
    cvv = request.json['card-cvv']
    expiry = request.json['card-expiry']
    cardNumber = request.json['card-number']
    params_dict = {"email":email, "amount": amount, "cvv": cvv, "expiry":expiry, "card_number":cardNumber, "country":country}
    isValidCard = False 
    isSuccess = False

    try:
      cursor = g.conn.execute(text("SELECT CHECK_CARD_MATCH(:email, :card_number, :expiry, :cvv, :country);"), params_dict)

      for result in cursor:
         if result[0]==True:
             isValidCard = True

      if isValidCard:
        params_dict = {"email":email,"card_number":cardNumber,"amount":amount,"country":country,"transaction_id":1}
        cursor = g.conn.execute(text("SELECT PROCESS_TRANSACTION(:email, :card_number, :amount, (SELECT M.MERCHANT_ID FROM MERCHANTS M WHERE M.MERCHANT_NAME ILIKE ('%Internetflix Ltd.%') AND M.COUNTRY_ID = (SELECT C.COUNTRY_ID FROM COUNTRIES C WHERE C.COUNTRY=:country)), :transaction_id);"), params_dict)

        for result in cursor:
          if result[0]==True:
             isSuccess = True

      g.conn.commit()

    # Close the cursor
      cursor.close()
    except Exception as error:
       print('Exception',error)
       isValid = False
    response = {
        "isValid": isValidCard,
        "isSuccess": isSuccess
    }
    response = {str(key): value for key, value in response.items()}
    return jsonify(result=response)

@app.route('/saveandpay', methods=['GET','POST'])
def saveandpay():
    email = request.json['email']
    country = request.json['country']
    amount = request.json['amount']
    cvv = request.json['card-cvv']
    expiry = request.json['card-expiry']
    cardNumber = request.json['card-number']
    params_dict = {"email":email, "amount": amount, "cvv": cvv, "expiry":expiry, "card_number":cardNumber, "country":country}
    isValidCard = False 
    isSuccess = False
    try:
      cursor = g.conn.execute(text("SELECT CHECK_CARD_MATCH(:email, :card_number, :expiry, :cvv, :country);"), params_dict)

      for result in cursor:
         if result[0]==True:
             isValidCard = True

      if isValidCard:
        #save the token before paying
        params_dict = {"email":email,"card_number":cardNumber,"country":country}
        cursor = g.conn.execute(text("SELECT CREATE_AND_SAVE_TOKEN((SELECT M.MERCHANT_ID::text FROM MERCHANTS M WHERE M.MERCHANT_NAME ILIKE ('%Internetflix Ltd.%') AND M.COUNTRY_ID = (SELECT C.COUNTRY_ID FROM COUNTRIES C WHERE C.COUNTRY=:country)), :card_number, :email);"), params_dict)

        params_dict = {"email":email,"card_number":cardNumber,"amount":amount,"country":country,"transaction_id":1}
        cursor2 = g.conn.execute(text("SELECT PROCESS_TRANSACTION(:email, :card_number, :amount, (SELECT M.MERCHANT_ID FROM MERCHANTS M WHERE M.MERCHANT_NAME ILIKE ('%Internetflix Ltd.%') AND M.COUNTRY_ID = (SELECT C.COUNTRY_ID FROM COUNTRIES C WHERE C.COUNTRY=:country)), :transaction_id);"), params_dict)

        for result in cursor2:
          if result[0]==True:
             isSuccess = True

      g.conn.commit()

    # Close the cursor
      cursor.close()
    except Exception as error:
       print('Exception',error)
       isValid = False
    response = {
        "isValid": isValidCard,
        "isSuccess": isSuccess
    }
    response = {str(key): value for key, value in response.items()}
    return jsonify(result=response)


@app.route('/chart-data', methods=['GET'])
def chart_data():
    fraud_query = text("""
    SELECT M.MERCHANT_NAME, (COUNT(CASE WHEN T.FRAUD = TRUE THEN 1 ELSE NULL END) * 100.0 / COUNT(*)) AS FRAUD_PERCENTAGE
    FROM MERCHANTS M
    INNER JOIN TRANSACTIONS T ON M.MERCHANT_ID = T.MERCHANT_ID
    GROUP BY M.MERCHANT_NAME;
    """)

    success_query = text("""
    SELECT M.MERCHANT_NAME, (COUNT(CASE WHEN T.TRANSACTION_STATUS = TRUE THEN 1 ELSE NULL END) * 100.0 / COUNT(*)) AS SUCCESS_PERCENTAGE
    FROM MERCHANTS M
    INNER JOIN TRANSACTIONS T ON M.MERCHANT_ID = T.MERCHANT_ID
    GROUP BY M.MERCHANT_NAME;
    """)

    avg_transactions_query = text("""
    SELECT M.MERCHANT_NAME, COUNT(*) AS AVERAGE_TRANSACTIONS
    FROM MERCHANTS M
    INNER JOIN TRANSACTIONS T ON M.MERCHANT_ID = T.MERCHANT_ID
    GROUP BY M.MERCHANT_NAME;
    """)

    # Execute the SQL queries
    fraud_data = g.conn.execute(fraud_query).fetchall()
    success_data = g.conn.execute(success_query).fetchall()
    avg_transactions_data = g.conn.execute(avg_transactions_query).fetchall()

    # Close the database connection
    g.conn.close()

    # Organize the data
    chart_data = {
        "fraud_percentage": [{'name': row[0], 'percentage': row[1]} for row in fraud_data],
        "success_percentage": [{'name': row[0], 'percentage': row[1]} for row in success_data],
        "average_transactions": [{'name': row[0], 'average': row[1]} for row in avg_transactions_data]
    }

    return jsonify(chart_data)


@app.route('/chart', methods=['GET'])
def chart():
   return render_template("charttest.html")

if __name__ == "__main__":
  import click

  @click.command()
  @click.option('--debug', is_flag=True)
  @click.option('--threaded', is_flag=True)
  @click.argument('HOST', default='0.0.0.0')
  @click.argument('PORT', default=8111, type=int)
  def run(debug, threaded, host, port):
    """
    This function handles command line parameters.
    Run the server using:

        python3 server.py

    Show the help text using:

        python3 server.py --help

    """

    HOST, PORT = host, port
    print("running on %s:%d" % (HOST, PORT))
    app.run(host=HOST, port=PORT, debug=debug, threaded=threaded)

  run()