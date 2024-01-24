## csv_functions
**csv_columnsort**\
Sorts data columns from Aa-Zz\

**csv_interpolater**\
Fills in blank data cells through [linear interpolation](https://en.wikipedia.org/wiki/Interpolation#Linear_interpolation) using the last available data and the next available data `x + ((z - x) / y) * i`\

**csv_remdups**\
Removes duplicate data eg. `Jan 1 - 321 subs` & `Jan 2 - 321 subs` (only keeps the first instance)

## data_for_processing
Combines all the functions in `csv_functions` to create a dataset to be used by [processing](https://processing.org/).

**Note:** Project files in this repo use `tsv` files instead of `csv` files which uses tabs to separate values instead of commas.

TSV: ![tsv preview](https://media.geeksforgeeks.org/wp-content/uploads/20211004222319/tsvtocsv3.png)
CSV: ![csv preview](https://media.geeksforgeeks.org/wp-content/uploads/20211004222321/tsvtocsv4.png)

## fonts
Pretty self explanatory, these are the fonts used to render text in the animation.\
**Note:** Font must be a [monospaced font](https://en.wikipedia.org/wiki/Monospaced_font) or else it will look weird.

Program used for converting from proportional fonts to monospaced fonts: [FontForge](https://fontforge.org/en-US/).

## prod_data
Sample data that was used in the animations.

Bar chart dataset format:\
**Row 1:** Names of channels (starting from column B)\
**Row 2:** Hex code of bar (starting from column B)\
**Row 3:** Name of icon image (x if same as name) (starting from column B) in `data/icons/name.jpg`\
**Row 4:** Indicator date (the green bar light thing) (used in origins smp sub count)\
**Row 5 and onwards:** Data (starting from column B)\
**Column A:** Dates (starting from row 5)

Line chart dataset format:\
**Row 1:** Names of channels (starting from column B)\
**Row 2:** Hex code of bar (starting from column B)\
**Row 3:** Just put "x"\
**Row 4 and onwards:** Data (starting from column B)\
**Column A:** Dates (starting from row 4)

## project_files
Processing project files, the code, and how they are structured.

## subs_scraper
Scrapes sub counts and puts them in a csv file.

**noxinfluencer**\
Input the channel ids in the `options.json`\
You can also edit the start date for the scraping (min. Jan 1, 2015)\
**Note:** This method may not work for all channels especially if they're small channels.

**socialblade_x**\
You need to download their socialblade **monthly** analytics page as "HTML ONLY" due to socialblade being strict about web scraping. You can also use the web archive as well.
Naming of html file: `ChannelName - 2008,2013,or,2019`\
Determining the year of the file:\
**2008:** Blue Graph ![2008 socialblade](https://i.imgur.com/hjQ1tXI.png)
**2013:** Red Graph ![2013 socialblade](https://i.imgur.com/6OXvyXA.png)
**2019:** Monthly Graph ![2019 socialblade](https://i.imgur.com/kjvLl1H.png)

You can add ` - anything` at the end of the file name if have more than 1 files on the same channel.


## yt_logo_downloader
Downloads youtube channel icons\
Input channel ids in `data.json`

## ytc_vids_metadata
Compiles the data received from the youtube api into a csv file.
(youtube videos)

# Requirements
Nodejs LTS version\
Processing (Java)\
Brain