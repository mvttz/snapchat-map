create temporary table if not exists areacoderank as (
select
  areacode,
  state,
  city,
( 
  case 
    when @curType = areacode
	   then @curRow := @curRow + 1 
    else @curRow := 1 and @curType := areacode
  end
) rank
from goodareacodes a,
  (select @curRow := 0, @curType := '') r
order by areacode,city
);

create temporary table if not exists areacodestats as (
select 
  substring(phone,1,3) as areacode,
  count(*) as count
from records
group by areacode
);

select
  r.areacode,
  r.state,
  r.city,
  s.count
from areacoderank r
	inner join areacodestats s
		on s.areacode = r.areacode
where r.rank = 1
order by s.count desc;