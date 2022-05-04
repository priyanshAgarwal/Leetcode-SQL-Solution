/*

Find the upward recommendation chain for member ID 27
Question
Find the upward recommendation chain for member ID 27: that is, the member who recommended them, and the member who recommended that member, and so on. Return member ID, first name, and surname. Order by descending member id.

Recursive CTE
*/




WITH RECURSIVE CTE AS(
  select recommendedby from cd.members where memid=27
  union all
  select b.recommendedby from CTE a inner join cd.members b on a.recommendedby=b.memid
)

select recs.recommendedby, mems.firstname, mems.surname
	from CTE recs
	inner join cd.members mems
		on recs.recommendedby = mems.memid
order by memid desc          
