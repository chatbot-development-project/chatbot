import time
from bs4 import BeautifulSoup
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager

output_file = "prettified_output.txt"

options = Options()
# driver = webdriver.Chrome('/home/gris/Downloads/chromedriver-linux64/chromedriver')  # Optional argument, if not specified will search path.
driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=options)

driver.get('https://www.sportybet.com/ng/sport/football/today');
# html_page = driver.page_source

soup = BeautifulSoup(driver.page_source, "lxml")

print (soup.text)

with open(output_file, "w") as f:
    f.write(soup.text)


time.sleep(5) # Let the user actually see something!

driver.quit()

