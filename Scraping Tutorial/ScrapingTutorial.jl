ScrapingTutorial.jl


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








