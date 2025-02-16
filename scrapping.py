
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from webdriver_manager.chrome import ChromeDriverManager
from selenium.common.exceptions import TimeoutException
import time
from flask import Flask, request, jsonify
from flask_cors import CORS


app = Flask(__name__)
CORS(app)

#product = input("ENTER THE PRODUCT NAME: ")

# ------------------------Zepto ------------------------

# def scrape_zepto(product_name):
#     # Set up Selenium options
#     options = Options()
#     # options.add_argument('--headless')  # Run in headless mode (no browser UI)
#     options.add_argument('--disable-gpu')
#     options.add_argument('--no-sandbox')
#     options.add_argument('--disable-dev-shm-usage')
    
#     # Initialize the WebDriver
#     driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=options)
    
#     try:
#         # Open the Zepto search URL
#         search_url = f"https://www.zeptonow.com/search?query={product_name}"
#         driver.get(search_url)
#         #print(driver.page_source)

#         # Wait for the page to load dynamically
#         time.sleep(5)  # Increase if necessary for slower connections
#         #<h4 class="font-heading text-lg tracking-wide line-clamp-1 !font-semibold !text-md !leading-4 !m-0" data-testid="product-card-price">₹208</h4>
#         wait = WebDriverWait(driver, 10)
#         # Find the price elements (update the XPath/CSS selector as needed)
#         # price_elements = driver.find_elements(By.CSS_SELECTOR, 'h4')  # Update with the actual selector for prices
#         # qty_elements = driver.find_elements(By.CSS_SELECTOR,'span')
#         price_elements = wait.until(EC.presence_of_all_elements_located((By.TAG_NAME, "h4")))
#         qty_elements = wait.until(EC.presence_of_all_elements_located((By.TAG_NAME, "span")))
#         #<h4 class="font-heading text-lg tracking-wide line-clamp-1 mt-1 !text-sm !font-normal">1 kg</h4>

#         # Extract the prices
#         prices = [price.text for price in price_elements]
#         qtys = [qty.text for qty in qty_elements]
#         # print("Zepto")
#         # output = prices[1] + ' Quantity: ' +qtys[4]
#         return {"price": prices[1] if len(prices) > 1 else "N/A", "quantity": qtys[4] if len(qtys) > 4 else "N/A"}
#     finally:
#         # Close the driver
#         driver.quit()

# Test the function
#scrape_zepto(product)
def scrape_zepto(product_name):
    # Set up Selenium options
    options = Options()
   # options.add_argument('--headless')  # Run in headless mode
    options.add_argument('--disable-gpu')
    options.add_argument('--no-sandbox')
    options.add_argument('--disable-dev-shm-usage')
    #options.add_argument('--disable-software-rasterizer')
    
    # Initialize the WebDriver
    driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=options)
    
    try:
        # Open the Zepto search URL
        search_url = f"https://www.zeptonow.com/search?query={product_name}"
        driver.get(search_url)

        wait = WebDriverWait(driver, 10)

        # Extract quantity
        try:
            qty_element = wait.until(
                EC.presence_of_element_located((By.CSS_SELECTOR, 'span[data-testid="product-card-quantity"] h4'))
            )
            quantity = qty_element.text.strip()
        except TimeoutException:
            quantity = "N/A"

        # Extract price
        try:
            price_element = wait.until(
                EC.presence_of_element_located((By.CSS_SELECTOR, 'h4[data-testid="product-card-price"]'))
            )
            price = price_element.text.strip()
        except TimeoutException:
            price = "N/A"

        return {"price": price, "quantity": quantity}

    except Exception as e:
        return {"error": str(e)}
    
    finally:
        driver.quit()

# --------------------------------------------------------------------------------------------------------------

def scrape_instamart(product_name):
    # Set up Selenium options
    options = Options()
   # options.add_argument('--headless')  # Run in headless mode (no browser UI)
    options.add_argument('--disable-gpu')
    options.add_argument('--no-sandbox')
    options.add_argument('--disable-dev-shm-usage')
    options.add_argument('--disable-software-rasterizer')

    
    # Initialize the WebDriver
    driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=options)
    
    try:
        # Open the Instamart search URL
        search_url = f"https://www.swiggy.com/instamart/search?custom_back=true&query={product_name}"
        driver.get(search_url)
        time.sleep(5)  # Wait for the page to load
       # print(driver.page_source)

        
        # Wait for price elements to load
        wait = WebDriverWait(driver, 20)  # Wait up to 20 seconds for elements
        
        # Select price elements (Ensure visibility)
        price_elements = wait.until(
            EC.visibility_of_all_elements_located((By.CSS_SELECTOR, 'div.sc-aXZVg.jLtxeJ.JZGfZ[aria-label]'))
        )
        prices = [price.get_attribute('aria-label') for price in price_elements]

        # Extract and print price from each price element
        # for price in price_elements:
        #     print(f"aria-label: {price.get_attribute('aria-label')}")
        #     print(f"Text: {price.text}")
        #     print(f"Outer HTML: {price.get_attribute('outerHTML')}")
        
        # Extract quantities
        qty_elements = wait.until(
            EC.visibility_of_all_elements_located((By.CSS_SELECTOR, 'div.sc-aXZVg.entQHA._3eIPt'))
        )

        qtys = [qty.text for qty in qty_elements]

        # Debug: Check the lengths and contents
        # print("Price elements found:", len(price_elements))
        # print("Quantities found:", len(qtys))

        # Extract the first available price and quantity (if present)
        # print("InstaMart\n")
        # if price_elements:
        #     print(f"Price: {price_elements[0].get_attribute('aria-label')}")
        # else:
        #     print("No prices found.")
        
        # if qtys:
        #     print(f"Quantity: {qtys[0]}")
        # else:
        #     print("No quantities found.")
        # print(price_elements[0].get_attribute('aria-label') , qtys[0])
        print({"price": prices[0] if price_elements else "N/A", "quantity": qtys[0] if qtys else "N/A"})
        return {"price": prices[0] if price_elements else "not found", "quantity": qtys[0] if qtys else "N/A"}
    finally:
        # Close the driver
        driver.quit()

# Test the function
#scrape_instamart(product)
#------------------------------------------------------------------------------------


# Create API endpoint to fetch scraped data
@app.route('/get-data', methods=['GET'])
def get_data():
    product = request.args.get('product')  # Get product name from the request
    if not product:
        return jsonify({"error": "Product name is required"}), 400

    result = {
        "site1": scrape_zepto(product) ,
        "site2": scrape_instamart(product)
    }
    print(jsonify(result))
    return jsonify(result)

if __name__ == '__main__':
    app.run(debug=True)