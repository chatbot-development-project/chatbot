##import re
##
### Append the new format "20/03 Wednesday" to the text data
##text_data = "06/03 Tuesday  20/03 Wednesday"
##
### Define the regular expression pattern
##regex_pattern = r'\b\d{2}/\d{2}\s(?:Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday)\b'
##
### Find all matches using the regular expression
##matches = re.findall(regex_pattern, text_data)
##
##print(matches)


import re

# Append the new format "20/03 Wednesday" to the text data
text_data = "ID Time Event  14:00   ID: 27649 North Macedonia Ukraine    4.30 3.70 1.732.5 ^  1.81 1.93 +143 14:00   ID: 28828 Switzerland Latvia    1.29 5.25 8.702.5 ^  1.62 2.20 +142 15:00   ID: 28777 Norway Montenegro    1.24 5.50 10.502.5 ^  1.70 2.10 +142 15:00   ID: 15287 Scotland Italy    7.10 4.50 1.402.5 ^  1.80 1.95 +143 15:00   ID: 27749 Serbia Denmark    3.10 3.50 2.152.5 ^  1.81 1.94 +143 15:30   ID: 27750 Croatia Germany    4.20 4.00 1.682.5 ^  1.59 2.25 +143 16:00   ID: 26306 Kosovo Austria    7.70 4.60 1.372.5 ^  1.83 1.92 +143 16:00   ID: 25332 Spain Slovenia    1.24 5.60 10.502.5 ^  1.64 2.15 +141 19:00   ID: 17144 Bosnia & Herzegovina Israel    4.00 3.50 1.822.5 ^  1.92 1.82 +143 19:00   ID: 16262 France Belgium    1.86 3.75 3.602.5 ^  1.71 2.05 +143 19:00   ID: 13355 Netherlands Lithuania    1.04 11.50 32.003.5 ^  1.89 1.85 +76 19:00   ID: 26564 Portugal Greece    1.19 6.20 13.002.5 ^  1.65 2.15 +142   International Clubs Club Friendly Games"

# Define the modified regular expression pattern
regex_pattern = r'ID: \d+.*?\d{2}:\d{2}'

# Find all matches using the modified regular expression
matches = re.findall(regex_pattern, text_data)

for matche in matches:
    print(matche)
    print ()


