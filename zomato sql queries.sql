Create Database zomato;
use zomato;
UPDATE zomato_11 
SET 
	Datekey_Opening = REPLACE(Datekey_Opening, '_', '/') 
    WHERE Datekey_Opening LIKE '%_%';
    
alter table zomato_11 
modify column Datekey_Opening date;

select * from zomato_11;
select count(RestaurantID) from zomato_11;
select count(countrycode) from zomato_11; 

#1. Country Map detail

select * from country_info;

#2. Calendar Table.

select 
	year(Datekey_Opening) years,
	month(Datekey_Opening) months,
	day(datekey_opening) day ,
	monthname(Datekey_Opening) monthname,
    Quarter(Datekey_Opening)as quarter,
	concat(year(Datekey_Opening),'-',
    monthname(Datekey_Opening)) yearmonth, 
	weekday(Datekey_Opening) weekday,
	dayname(datekey_opening)dayname, 

case 
	when monthname(datekey_opening) in ('January' ,'February' ,'March' )then 'Q1'
	when monthname(datekey_opening) in ('April' ,'May' ,'June' )then 'Q2'
	when monthname(datekey_opening) in ('July' ,'August' ,'September' )then 'Q3'
else  'Q4' end as quarters,

case 
	when monthname(datekey_opening)='December' then 'FM-9' 
	when monthname(datekey_opening)='January' then 'FM-10'
	when monthname(datekey_opening)='February' then 'FM-11'
	when monthname(datekey_opening)='March' then 'FM-12'
	when monthname(datekey_opening)='April'then'FM-1'
	when monthname(datekey_opening)='May' then 'FM-2'
	when monthname(datekey_opening)='June' then 'FM-3'
	when monthname(datekey_opening)='July' then 'FM-4'
	when monthname(datekey_opening)='August' then 'FM-5'
	when monthname(datekey_opening)='September' then 'FM-6'
	when monthname(datekey_opening)='October' then 'FM-7'
	when monthname(datekey_opening)='November' then 'FM-8'
end Financial_months,

case 
	when monthname(datekey_opening) in ('January' ,'February' ,'March' )then 'Q4'
	when monthname(datekey_opening) in ('April' ,'May' ,'June' )then 'Q1'
	when monthname(datekey_opening) in ('July' ,'August' ,'September' )then 'Q2'
else  'Q3' end as financial_quarters

from zomato_11;

#3. Find the Numbers of Resturants based on City and Country.

select Country_Info.Country_Name, zomato_11.city, count(restaurantid) as Restaurants
from zomato_11 inner join Country_Info 
on zomato_11.CountryCode = Country_Info.CountryCode 
group by Country_Info.Country_Name, zomato_11.city;

#4. Numbers of Resturants opening based on Year , Quarter , Month.

select 
	year(datekey_opening)as Year,
	quarter(datekey_opening) as Quarter, 
	monthname(datekey_opening) as Month, 
    count(restaurantid) as Restaurants 
from zomato_11 
	group by year(datekey_opening),quarter(datekey_opening),monthname(datekey_opening) 
	order by year(datekey_opening), quarter(datekey_opening), monthname(datekey_opening) ;

#5. Count of Resturants based on Average Ratings.

select 
case 
	when rating <=2 then "Low" 
    when rating <=3 then "Average" 
    when rating <=4 then "Good" 
    when Rating <=5 then "Excellent" 
    end rating_type, count(restaurantid) as Restaurants
from zomato_11 
	group by rating_type 
	order by rating_type;

#6. Create buckets based on Average Price of reasonable size and find out how many resturants falls in each buckets.

select 
case 
	when price_range=1 then "0-500" 
    when price_range=2 then "500-3000" 
    when Price_range=3 then "3000-10000" 
    when Price_range=4 then ">10000" 
    end price_range, count(restaurantid) as Restaurants
from zomato_11 
group by price_range
order by Price_range desc;

#7. Percentage of Resturants based on "Has_Table_booking"

select has_online_delivery, concat(round(count(Has_Online_delivery)/100,1),"%") percentage 
from zomato_11 
group by has_online_delivery;

#8. Percentage of Resturants based on "Has_Online_delivery"

select has_table_booking, concat(round(count(has_table_booking)/100,1),"%") percentage 
from zomato_11 
group by has_table_booking;

#9. highest rating restaurants in each country 

select  country_name, restaurantname, max(rating) as highest_rating 
from zomato_11 
inner join country_info on zomato_11.countrycode=country_info.countrycode
group by country_info.country_name, restaurantname, rating
order by rating desc ;

#10. Top 5 restaurants who has more number of votes

select  country_name, restaurantname, votes, Average_Cost_for_two 
from zomato_11 
inner join country_info on zomato_11.countrycode = country_info.countrycode
group by country_info.country_name, restaurantname, votes, Average_Cost_for_two
order by votes desc limit 5;

#11. top restaurant with highest rating and votes from each country

select  country_name, restaurantname, max(rating) as highest_rating, max(votes) as Votes
from zomato_11 
inner join country_info on zomato_11.countrycode = country_info.countrycode
group by country_name, restaurantname, rating, votes
order by votes desc limit 5;

#12. Ciusines per Restaurants

SELECT cuisines, count(cuisines) as Offered_in_Restaurants
FROM zomato_11
group by  cuisines ;

#13. Most liked Cuisines by Votes

SELECT cuisines, round(count(votes),0) as Votes
FROM zomato_11
group by cuisines, votes;
