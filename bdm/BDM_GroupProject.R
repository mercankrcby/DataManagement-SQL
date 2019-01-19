install.packages("RPostgreSQL")

remove.packages("DBI")
install.packages("DBI")


require("RPostgreSQL")

# create a connection
# save the password that we can "hide" it as best as we can by collapsing it
pw <- {
  "mk1234"
}
# loads the PostgreSQL driver
drv <- dbDriver("PostgreSQL")

# creates a connection to the postgres database
# note that "con" will be used later in each connection to the database
con <- dbConnect(drv, dbname = "postgres",
                 host = "localhost", port = 5432,
                 user = "postgres", password = pw)

rm(pw) # removes the password

# check for the cartable
dbExistsTable(con, "black_friday")


# query the data from postgreSQL 
df_customer <- dbGetQuery(con, "SELECT * from customer")

df_product <- dbGetQuery(con, "SELECT * from product")

df_transaction <- dbGetQuery(con,"SELECT * from product Transaction limit 10")

df_AgeGroupFilter <- dbGetQuery(con,"SELECT C.AGE_BRACKET, C.GENDER,
SUM(T.PURCHASE) TOTAL_PURCHASE 
FROM TRANSACTION T INNER JOIN CUSTOMER C
ON T.CUSTOMER_ID = C.CUSTOMER_ID
GROUP BY C.AGE_BRACKET, C.GENDER
ORDER BY 3 DESC ")

df_AgeGroupFilter

df_customer$customer_id
df_product
df_transaction

# TRUE

ggplot(df_AgeGroupFilter,aes(x=df_AgeGroupFilter$age_bracket,
           y=df_AgeGroupFilter$total_purchase,
           color=gender))+
  geom_point()

Total Values 

ggplot(df_AgeGroupFilter, aes(x=df_AgeGroupFilter$age_bracket,y=df_AgeGroupFilter$total_purchase)) + 
  geom_bar(stat="identity")

df_innerCustomerProduct <- dbGetQuery(con,"SELECT T.CUSTOMER_ID, 
                                      COUNT(DISTINCT P.PRODUCT_CATEGORY_1) PRODUCT_CATEGORY_CNT, 
                                      SUM(T.PURCHASE) TOTAL_PURCHASE, 
                                      C.GENDER,  C.AGE_BRACKET,  C.OCCUPATION_CODE, C.CITY_CATEGORY FROM TRANSACTION T INNER JOIN PRODUCT P
                                      ON T.PRODUCT_ID = P.PRODUCT_ID
                                      INNER JOIN CUSTOMER C
                                      ON T.CUSTOMER_ID = C.CUSTOMER_ID
                                      GROUP BY T.CUSTOMER_ID,  T.PURCHASE, C.GENDER, C.AGE_BRACKET, C.OCCUPATION_CODE, C.CITY_CATEGORY ORDER BY 3 DESC;
                                      ")

df_innerCustomerProduct



p3 <- ggplot(df_AgeGroupFilter,
             aes(x = df_AgeGroupFilter$age_bracket,
                 y = df_AgeGroupFilter$total_purchase)) + 
  theme(legend.position="top",
        axis.text=element_text(size = 6))
(p4 <- p3 + geom_point(aes(color = df_AgeGroupFilter$gender),
                       alpha = 0.5,
                       size = 1.5,
                       position = position_jitter(width = 0.25, height = 0)))


p5 <- ggplot(df_AgeGroupFilter, aes(df_AgeGroupFilter$age_bracket, y = df_AgeGroupFilter$total_purchase))
p5 + geom_line(aes(color = df_AgeGroupFilter$gender))  


#Customer City Category
pc1 <- ggplot(df_innerCustomerProduct, aes(x = df_innerCustomerProduct$age_bracket, y = df_innerCustomerProduct$total_purchase, color = df_innerCustomerProduct$city_category))
pc1 + geom_point()

pc2 <- pc1 +
  geom_smooth(mapping = aes(linetype = "r2"),
              method = "lm",
              formula = y ~ x + log(x), se = FALSE,
              color = "red")
pc2 + geom_point()

# Gender - Total Purchase
ggplot(data=df_AgeGroupFilter,aes(x="",y = df_AgeGroupFilter$total_purchase,fill=df_AgeGroupFilter$gender)) +
  geom_bar(stat="identity",width=1) +
  coord_polar("y",direction=-1) +
  theme_void() +
  labs(fill="")

#Age Bracket - Total Purchase
pie( df_AgeGroupFilter$total_purchase, labels = df_innerCustomerProduct$age_bracket, main="Pie Chart of Age_Bracket")