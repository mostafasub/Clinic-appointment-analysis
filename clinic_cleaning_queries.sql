-- Appintment table:
-- duplicates
select patient_id, doctor_id, appointment_date, COUNT(*) as duplicate_count from appointment
group by patient_id, doctor_id, appointment_date
having count(*) > 1;

-- cleaned version of appointment 
create table cleaned_appointment as
with appointments as (
    select *,
	row_number() over (partition by patient_id, doctor_id, appointment_date order by
		case when status = 'completed' then 1
			when status = 'Cancelled' then 2
			else 3 end,
		appointment_id
) as row_num
from appointment
)
select appointment_id, patient_id, doctor_id,
date(appointment_date) as appointment_date,
time(appointment_date) as appointment_time,
notes,
case 
    When status is null then 'scheduled'
	When status = 'cancelled' Then 'cancelled'
	Else status
end as status
from appointments
Where row_num = 1;

-- Patient table:
-- rename dob column to birthdate
alter table patient rename column dob to birthdate;

-- deleting phone_number column and address
alter table patient drop column phone_number;
alter table patient drop column address;
