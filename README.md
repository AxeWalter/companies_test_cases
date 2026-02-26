# ZipBoard Technical Assessment - Crawler and Gemini Integration

The goals of this assessment were:
- Catalog in a spreadsheet all existing help articles in the zipboard help center
- Enhance the information about these articles through AI
- Automatically update the spreadsheet when new articles are published or existing ones are modified
- Integrate AI/LLM to search for documentation gaps. The goal here is to draw two article outlines that "are missing" from the documentation.

  
To accomplish that we split the tasks into three different python scripts and one extra to “orchestrate the CRON job”. They are: scraper.py, updates.py, gaps_analysis.py and main.py.

## scraper.py

- The core logic of the project is in this file. It effectively crawls through all the articles available in https://help.zipboard.co/
- We first open all the categories in the website. After that, we open each article in the category scraping for article name, category, URL, last updated, word count, checks for screenshots and video and extracts the text for latter analysis
- After each scrape the URL is saved in a SET so we can avoid duplicates (this is important because the same article appears in multiple categories)
- For the content classification data, we use a simple `if-elif` analyzing the title
- For the ID a simple increment after each loop was used
- The second part of this script was designed to enhance the data with the help of the Gemini API. The data is batched, using 40 articles in each submission, and the article id, title and text is feed to Gemini asking for 4 technical topics (`topics covered`) and for the individual gaps identified (`gaps identified`) in the articles. A JSON object is expected as return
- The new information is added to the original data, enhancing the scraped data
- The text column is removed from the data (it’s not further necessary)
- This data is saved to a provided excel file path

## updated.py

- This script is responsible for updating the excel file if any of the defined changes are found
- We first start by doing a fresh scrape with the help of `scraper.py`. This gathers fresh data to compare with the stored one
- Loads the local data for comparison
- If a new URL is detected or a change in the last updated happens, we save the rows affected for further processing
- If no changes were detected, we stop and print a console message explaining that no changes were detected
- If changes were detected, we submit the new data to be enhanced through the same logic used in `scraper.py`
- The changed rows are saved the provided excel file path

## gaps_analysis.py

gaps_analysis.py

- This script is responsible for generating the top 10 gaps in the documentation and, using those 10 gaps, point the two most important and draw an article outline for them
- We firs load the excel file so we can work on the stored data
- We submit article id, category, article name and gaps identified, together with a prompt, to Gemini API asking for the top 10 global documentation gaps
- We handle the expected Gemini JSON return and save to an excel with the following structure: gap id, category, gap description, priority, suggested article title and rationale
- The second part of this script is finding the 2 most important gaps in these 10. This is done by feeding Gemini the excel created in the last step together with a prompt. It's expected that Gemini delivers the gap id, selection rationale and the article outline
- The expected Gemini JSON is handled and saved to another sheet inside the top 10 global documentation gaps excel file

## main.py

- This is the script that allows the updated.py to be a CRON job
- We simply use the schedule python library to define a job that should run every day at 08am system time
- It’ll run in the background checking every 60 seconds for the time

## Workflow Diagram

<img width="2054" height="2649" alt="workflow diagram" src="https://github.com/user-attachments/assets/aa349746-92e2-4863-b3d1-c94bbc5e2a63" />










