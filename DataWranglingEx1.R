# Data Wrangling Excercise 1: Basic Data Maniplulation
# Rob Wallace, roblwallace@gmail.com
# 5-SEPT-2016
#
# [X] 0. Load the data in RStudio
# [X] 1. Clean Up Brand Names
# [X] 2. Separate product code and number
# [X] 3. Add product categories
# [X] 4. Add full address for geocoding
# [X] 5. Create dummy variables for company and product category
# [X] 6. Submit the project on Github

# Get Library or Package Wanted
library(dplyr)

# Step 0. Load the data in RStudio into a data frame
df_purchases = read.csv("refine_original.csv")
glimpse(df_purchases)

# Step 1. Clean Up Brand Names. All caps seems like a better choice for potential reports
# All Caps For Brand Names
df_purchases <- mutate_each(df_purchases, funs(toupper), company)
# Clean Up Spelling Errors within List
# If first letter is desired letter, replaces the word with <replacement>.
df_purchases$company <- gsub("^P.*$", "PHILIPS", df_purchases$company)
df_purchases$company <- gsub("^A.*$", "AKZO", df_purchases$company)
df_purchases$company <- gsub("^U.*$", "UNILEVER", df_purchases$company)
df_purchases$company <- gsub("^F.*$", "PHILLIPS", df_purchases$company)

# Grab the product code from column (Product.code...number) & put into a new column called (product_code) 
df_purchases <- mutate(df_purchases, product_code = substr(df_purchases$Product.code...number,1,1))

# Grab the product number from column (Product.code...number) & put into a new column (product_number)
df_purchases <- mutate(df_purchases, product_number = substr(df_purchases$Product.code...number, 3, length(df_purchases$Product.code...number)))

# Add a product_category column, and populate with corresponding entry of:
#   p = Smartphone, v = TV, x = Laptop, q = Tablet
# Create a new column and insert a plug value for now
df_purchases <- mutate(df_purchases, product_category = "plug")

# Loop through the data frame and place a correct value 
for (i in 1:nrow(df_purchases)) {
  print(df_purchases$product_code[i])
  if (df_purchases$product_code[[i]] == "q") {
    df_purchases$product_category[[i]] <- "Tablet"
  } 
  if (df_purchases$product_code[[i]] == "v") {
    df_purchases$product_category[[i]] <- "TV"
  }
  if (df_purchases$product_code[[i]] == "x") {
    df_purchases$product_category[[i]] <- "Laptop"
  }
  if (df_purchases$product_code[[i]] == "p") {
    df_purchases$product_category[[i]] <- "Smartphone"
  }
}

# Add full address for geocoding concatenate Address, City, State in a column
df_purchases <- mutate(df_purchases, full_address = paste(df_purchases$address, df_purchases$city, df_purchases$country, sep = ","))

# Create dummy binary variables for company and product category
# Add four binary columns for company's (future analysis)
df_purchases <- mutate(df_purchases, company_philips = FALSE)
df_purchases <- mutate(df_purchases, company_akzo = FALSE)
df_purchases <- mutate(df_purchases, company_van_houten = FALSE)
df_purchases <- mutate(df_purchases, company_unilever = FALSE)

# Add four binary columns for products (future analysis)
df_purchases <- mutate(df_purchases, product_smartphone = FALSE)
df_purchases <- mutate(df_purchases, product_tv = FALSE)
df_purchases <- mutate(df_purchases, product_laptop = FALSE)
df_purchases <- mutate(df_purchases, product_tablet = FALSE)

# Create massaged output file as a .csv in working directory
write.csv(df_purchases, file = "refine_clean.csv")


