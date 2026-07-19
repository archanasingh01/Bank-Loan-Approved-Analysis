                                          -- Bank loan analyses  

-- creating a database named bank loan analysis 
create database bank_loan_analysis;

use bank_loan_analysis;

-- counting number of rows present in tables loan applications 
select count(*) from loan_applications;

-- showing names of all column present in the table loan applications 
show columns from loan_applications;

-- total loan applications group by loan status
select loan_status, count(*) as approved_loans
from  loan_applications
group by loan_status;

-- total applications, average income, average loan amount, average intrest rate group by loan status
select loan_status, count(*) as total_applications, avg(person_income) as avg_income, avg(loan_amnt) as avg_loan_amount, avg(loan_int_rate) as avg_intrest_rate
from loan_applications
group by loan_status;

-- loan approval rate for each loan intent
with loan_approval_rate as
(
  select loan_intent, count(*) as approval_status
  from loan_applications
  where loan_status = 1
  group by loan_intent
),
loan_intent_level as 
(
  select loan_intent, count(*) as total_applications
  from loan_applications
  group by loan_intent
)
select la.loan_intent,
	   la.approval_status,
       li.total_applications,
       (la.approval_status * 100 / li.total_applications) as approval_rate
	from loan_approval_rate as la
    join loan_intent_level as li on
    la.loan_intent = li.loan_intent
    order by approval_rate desc;
    
 -- loan approval rate for each home ownership type
 with loan_approval_rate as
(
  select person_home_ownership, count(*) as approval_status
  from loan_applications
  where loan_status = 1
  group by person_home_ownership
),
home_ownership_level as 
(
  select person_home_ownership, count(*) as total_applications
  from loan_applications
  group by person_home_ownership
)
select la.person_home_ownership,
	   la.approval_status,
       hl.total_applications,
       (la.approval_status * 100 / hl.total_applications) as approval_rate
	from loan_approval_rate as la
    join home_ownership_level as hl on
    la.person_home_ownership = hl.person_home_ownership
    order by approval_rate desc;
    
-- total applicatins, approved loans, approval rate(%), average loan amount of approved applicants for each loan grade
select loan_grade, count(*) as total_applications,
   sum(case 
         when loan_status = 1 then 1
         else 0
         end) as approved_loans,
   round(sum(case
               when loan_status = 1 then 1
               else 0
               end)*100 / count(*), 2) as approval_rate,
	round(avg(case
                when loan_status = 1 then loan_amnt
                end), 2) as avg_approved_loan_amount
from loan_applications
group by loan_grade
order by approval_rate desc;

-- top 5 occupations (loan intent) where the average loan amount is the highest
select loan_intent, count(*) as approved_loan, round(avg(loan_amnt), 2) as average_approved_loan_amount
from  loan_applications
where loan_status = 1
group by loan_intent
order by average_approved_loan_amount desc
limit 5 ;
  
-- Average intrest rate for each loan grade, but only for approved loans
select loan_grade,  count(*) as approved_loan, round(avg(loan_int_rate), 2) as avg_loan_intrest_rate
from loan_applications
where loan_status = 1
group by loan_grade
order by avg_loan_intrest_rate desc;

 -- loan intent analysis
 select loan_intent, count(*) as total_applications,
    sum(case
          when loan_status = 1 then 1 
          else 0
          end) as approved_loan,
	sum(case
          when loan_status = 0 then 1
          else 0
          end) as rejected_loan,
	round(sum(case
                when loan_status = 1 then 1
                else 0
                end) * 100 / count(*), 2) as approval_rate,
	round(avg(case
                when loan_status = 1 then loan_amnt
                end), 2) as avg_loan_amount
from loan_applications
group by loan_intent
order by approval_rate desc;

-- top 5 highest risk loan intent
select loan_intent, count(*) as total_applications,
  round(sum(case
              when loan_status = 1 then 1
              else 0
              end) * 100 / count(*), 2) as approval_rate,
  round(avg(case
              when loan_status = 1 then loan_int_rate
              end), 2) as avg_approved_intrest_rate
from loan_applications
group by loan_intent
order by approval_rate asc, 

avg_approved_intrest_rate desc;