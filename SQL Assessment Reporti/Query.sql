with sample as (select *,LEFT(string(Opp_Start_Date), 7) AS Month  from `xenon-diorama-340205.AJMAN_test_dataset.Analytical_task`),
sample1 as (select Month,sum(MRR_expected_) as MRR, count(Unique_Account_Field) as No_of_customers from sample group by Month order by Month),
sample2 as (select *,Lag(MRR,12) over(order by Month) as LastYearRevenue,lag(No_of_customers, 12) over(order by Month) as Prev_total_customers from sample1 order by Month)
 select Month,
 MRR as Revenue_this_month,
 LastYearRevenue as Revenue_12_Months_ago,
 case when MRR>LastYearRevenue then MRR-LastYearRevenue end as Upsell,
 case when MRR<LastYearRevenue then MRR-LastYearRevenue end as Downsell,
 case when No_of_customers>Prev_total_customers then MRR-LastYearRevenue end as Newcustomers,
 case when No_of_customers<Prev_total_customers then MRR-LastYearRevenue end as Churn
  from sample2
