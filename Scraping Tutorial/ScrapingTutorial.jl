ScrapingTutorialEx1.jl



# Ex1: Scrape an HTML table and convert to a CSV file
#Small HTML Website

#get HTML 

using HTTP

url = "https://dabblingdoggo.github.io/mysite3/doggo/data.html"

r = HTTP.get(url)

# parse HTML

using Gumbo

h = parsehtml(String(r.body))

#the parsehtml function takes HTML and assigns index numbers to each HTML element based on an index structure
#Use a series of integers inside square brackets

#Head vs body


h.root[1]

h.root[2]

body = h.root[2]

#Go to website and RC, Click "View Page Source"
# This will show you all the HTML code. The body is everything with the body element tags
# Within the body are several elements that are indented.
# You can refer to each of those elements using an index number

body[1]

body[2]

body[3]

body[4]

#Note that <div class="overflow"> is line 40 in the page source, and where the data table starts.
#The table element is indeed the fourth element, just as we thought

#In the page source, it looks like the table data is wrapped in a few more elements. 
#So, you need to figure out how to index the actual table.

body[4][1]

body[4][1][1]

#Data is indexed at body[4][1][1]

table = body[4][1][1]

# HTMLElement{} are just structs.
# Use ".children" to show each individual row of data in the table

table.children

nrows = length(table.children)

# identify pattern for indexing rows and columns

table[1]

table[2]

table[3]

# First index number is the row number

header = table[1]

header.children

ncols = length(header.children)

#Note that you can obviously use any row to figure out how many columns there are, not just the header row.

table[1][1]

table[1][2]

table[1][3]

# The second set of index numbers will give us the column information
# Next, how to get to the actual text without the HTML element tags?

table[1][1][1].text

# The actual text is then one more layer deep. You can extract the actual text by using the ".text" syntax
# The pattern is table[row][col][1].text 

vector = String[]

for row in 1:nrows
    for col in 1:ncols
        push!(vector, table[row][col][1].text)
    end
end

vector

# Reshape column vector 

matrix = reshape(vector, (4, 4))

#Note that since Julia is column-major ordered, the header is actually in the first column, and not the first row
#If you want to transpose, do the following
#Transpose function only works for numbers.
#Therefore, you need to use the permutedims() function, which does the same thing only for strings

p_matrix = permutedims(matrix)

#Save CSV file

using DelimitedFiles

writedlm("client-list.csv", p_matrix, ',')

# Success!

# Example 2: Larger HTML table

# get HTML

using HTTP

url = "https://dabblingdoggo.github.io/mysite11/"

r = HTTP.get(url)

# parse HTML

using Gumbo

h = parsehtml(String(r.body))

body = h.root[2]

#find table element in HTML body

body[1]

body[1].children

body[1][38]

body[1][38][1]

table = body[1][38][1]

nrows = length(table.children)

# Identify pattern for rows and columns in this table

table[1]

table[2]

table[3]

header = table[1]

ncols = length(header.children)

table[1][1]

table[1][2]

table[1][3]

#Second index is the column number

table[1][1][1]

# Pattern is table[row][col][1].text
# Scrape the table into the column vector

vector = String[]

for row in 1:nrows
    for col in 1:ncols
        push!(vector, table[row][col][1].text)
    end
end

vector

# This is a much larger column vector
# Reshape it to see how things look

matrix = reshape(vector, (ncols, nrows))

# The first number is the number of rows, and the second number is the number of columns
# Julia arrays are column major ordered. See how headers are in the first column, and not in the first rows. 
# To transpose matrix to allow headers to be in the first row, use permutedims again.

p_matrix = permutedims(matrix)

# Save the CSV file

using DelimitedFiles

writedlm("world-population.csv", p_matrix)

# Note that not all data in webpages are found neatly in tables. 
# But you can still scrape web data that isn't stored in a table. See the following.

#Example Number 3

using HTTP

url = "https://dabblingdoggo.github.io/mysite3/doggo/about.html"

r = HTTP.get(url)

# Parse the HTML

using Gumbo

h = parsehtml(String(r.body))

body = h.root[2]

# Now count the elements from the page source. 

body[4]

data = body[4]

# Find out how many cards are on the page programatically

data.children

nrows = length(data.children)

# Now, identify the location of the actual text and see if we can identify a pattern.

data[1]

data[2]

data[3]

# First element appears to be the row.

data[1][1]

# Second element appears to be the container class.

data[1][1][1]

# Third element appears to be the image element. Not what we want.

data[1][1][2]

# The above (data[1][1][2]) appears to be the div element with the label, so we're getting closer. 

data[1][1][2][1]

#This contains the actual text so this is what we're looking for.

# Pattern is data[row][1][2][1].text
# Scrape the data into a column vector

staff = String[]

# Now, use a simple for loop to push our data into a column vector.

for row in 1:nrows
    push!(staff, data[row][1][2][1].text)
end

staff

# Name and title are combined in the text. Here we will split the information and add header names.

staff2 = String["Name", "Title"]

for row in 1:nrows
    for col in 1:2
        push!(staff2, split(staff[row], ",")[col])
    end
end

staff2

# So we've gone from a three-element column vector to an eight-element column vector. 
# As before, let's reshape it 
# matrix = reshape(vectorname, (# rows, # columns))

matrix = reshape(staff2, (2, 4))
p_matrix = permutedims(matrix)

# Save CSV file

using DelimitedFiles

writedlm("staff-gumbo.csv", p_matrix, ',')

# It's worth noting that you can't scrape label classes with Gumbo, but you can with Cascadia. This is what we're doing in the next example.


# Example 4: Scrape Non-Tabular data using Gumbo + Cascadia and convert it into a CSV file.

# Get HTML

using HTTP

url = "https://dabblingdoggo.github.io/mysite3/doggo/about.html"

r = HTTP.get(url)

# Parse HTML

using Gumbo

h = parsehtml(String(r.body))

body = h.root[2]

# Find label class sector in HTML body.

using Cascadia

s = eachmatch(Selector(".label"), body)

# eachmatch function is from Julia base that returns all matches which meet the search criteria
# Selector is a mutable struct used in Cascadia that you can use to find a base HTML element, a class selector using the dot syntax, or an ID selector using the hashtag syntax.
# We're looking for a class selector ".label".

# Identify pattern

s[1]

s[2]

s[3]

# The first index is the row.

s[1][1]

s[1][1].text

# The above (s[1][1]) is what we're looking for. This is the pattern.
# Pattern is s[row][1].text

# Scrape the data into a column vector

nrows = length(s)

staff = String[]

for row in 1:nrows
    push!(staff, s[row][1].text)
end

staff

# split names and titles

staff2 = String["Name", "Title"]

for row in 1:nrows
    for col in 1:2
        push!(staff2, split(staff[row], ",")[col])
    end
end

staff2

#Reshape the column vector.

matrix = reshape(staff2, (2, 4))

p_matrix = permutedims(matrix)

# Save CSV file

using DelimitedFiles

writedlm("staff-cascadia.csv", p_matrix, ',')

# If scraping a larger website, Cascadia can come in very handy. 

# Example 5: Scrape a Wikipedia article. 

using HTTP

url = "https://en.wikipedia.org/wiki/ISO_3166-1"

r = HTTP.get(url)

# Parse HTML

using Gumbo

h = parsehtml(String(r.body))

body = h.root[2]

# Find class selector in HTML body

using Cascadia

# Go to Page Source on the Wikipedia page. Search (Ctl/Cmd + F) for "<table". It looks like there are five tables on this webpage.
# We're interested in the second one.
# This table element has a class named "wikitable sortable"
# Now, use Cascadia to find that table.
# For a fun example, we're going to use Cascadia to find all the table elements, in order to show that Cascadia works with all HTML elements.

eachmatch(Selector("table"), body)

#s = eachmatch(Selector(".wikitable sortable"), body)

# Why did Cascadia return an empty vector from the above? Because Cascadia doesn't like it when you use white spaces in class names. Instead, use a ".".

s = eachmatch(Selector(".wikitable.sortable"), body)

# Identify pattern

s[1]

s[2]

s[2][1]

s[2][2]

s[2][2].children

table = s[2][2]

nrows = length(table.children)

table[1]

table[2]

table[3]

# 1st index is the row

table[1][1]

table[1][2]

table[1][3]

# Second index is the col
# Pattern is table[row][col]...

# The data in this table follows a new pattern. There is a mix between columns that have images, columns that have hyperlinks, text only, or a combination of all.
# While it would be nice to find a pattern that fits the entire table, sometimes it's nicer to split up the takes
# by separating the header from the data and then separating the data into individual column vectors.

# It's actually easier in this case to make the header manually.

# Start by trying to find a pattern for the column containing the list of countries.

# countries

table[2][1][1]

table[2][1][2]
# This looks like an anchor tag, so our text must be one layer in.

table[2][1][2][1]
# Yup!

table[2][1][2][1].text

# Pattern appears to be table[row][col][2][1].text
#Check a couple other countries to see if this pattern continues.

table[3][1][2][1].text

table[3][1][2][1][1].text
# In the case of the islands, the pattern is slightly different. Notice how the pattern from Afghanistan yielded an error message.

table[4][1][2][1]
table[5][1][2][1]

#=
    pattern for countries is either 
        table[row][col][2][1].text or
        table[row][col][1][1][1].text
=#

countries = String[]

# Use the "try - catch" syntax, where Julia will try the first pattern and if it returns an error, try the second pattern.

col = 1

for row in 2:nrows
    try
        push!(countries, table[row][col][2][1].text)
    catch
        push!(countries, table[row][col][2][1][1].text)
    end
end

countries
# So that worked! Remember that we skipped the header row.

# alpha-2 code

table[2][2]
table[2][2][1]
table[2][2][1][1]
table[2][2][1][2]
table[2][2][1][2][1]
table[2][2][1][2][1].text

table[3][2][1][2][1].text
table[4][2][1][2][1].text

# Pattern is table[row][col][1][2][1].text

alpha2 = String[]

col = 2

for row in 2:nrows
    push!(alpha2, table[row][col][1][2][1].text)
end

alpha2

# Now there's a column vector with 249 alpha 2 country codes. 

table[2][3]
table[2][3][1]
table[2][3][2]
table[2][3][2][1]
table[2][3][2][1].text

table[3][3][2][1].text
table[4][3][2][1].text

# Pattern is table[row][col][2][1].text

alpha3 = String[]

col = 3

for row in 2:nrows
    push!(alpha3, table[row][col][2][1].text)
end

alpha3

# In the table, the column with the alpha3 codes has the same structure as the column with the numeric data. 
# Let's see if the same structure will work.

table[2][4][2][1].text
table[3][4][2][1].text
table[4][4][2][1].text

# Pattern is table[row][col][2][1].text
# It worked, so we can use the same pattern, and just change the column number. 

num_code = String[]

col = 4

for row in 2:nrows
    push!(num_code, table[row][col][2][1].text)
end

num_code

# Subdivision codes

table[2][5]
table[2][5][1]
table[2][5][1][1]
table[2][5][1][1].text

table[3][5][1][1].text
table[4][5][1][1].text

# Pattern is table[row][col][1][1].text

sub_code = String[]

col = 5

for row in 2:nrows
    push!(sub_code, table[row][col][1][1].text)
end

sub_code

# Independent

table[2][6]
table[2][6][1]
table[2][6][1].text
table[3][6][1]
table[3][6][1].text

# Pattern is table[row][col][1].text
# But, we're also picking up an escape character (the "/n"). In Julia this can be removed by using the rstrip() Function.
# rstrip removes characters from the right side of the string. 
# lstrip removes characters from the left side of the string

rstrip(table[2][6][1].text)
rstrip(table[3][6][1].text)
rstrip(table[3][6][1].text)

independent = String[]

col = 6

for row in 2:nrows
    push!(independent, rstrip(table[row][col][1].text))
end

independent

# All the data has successfully been scraped. 

# Now, assemble a matrix with a header and then we can save our scraped data to it.

# Assemble data

data = [countries alpha2 alpha3 num_code sub_code independent]

# Create header

header = ["countries" "alpha2" "alpha3" "num_code" "sub_code" "independent"]

# assemble matrix

matrix = [header; data]

# Save CSV file

using DelimitedFiles

writedlm("country-codes.csv", matrix, ",")






















