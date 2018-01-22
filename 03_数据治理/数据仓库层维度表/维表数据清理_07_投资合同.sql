--���1����Ч�����ظ�
select a.c_cont_code,
       a.l_effective_date,
       max(a.l_cont_id) as l_max_id,
       min(a.l_cont_id) as l_min_id
  from dim_ic_contract a
 group by a.c_cont_code, a.l_effective_date
having count(*) > 1;

--���2��ʧЧ�����ظ�
select a.c_cont_code,
       a.l_expiration_date,
       max(a.l_cont_id) as l_max_id,
       min(a.l_cont_id) as l_min_id
  from dim_ic_contract a
 group by a.c_cont_code, a.l_expiration_date
having count(*) > 1;

--���3��������Ч���ڴ���ʧЧ����
select *
  from dataedw.dim_ic_contract a
 where a.l_effective_date >= a.l_expiration_date;

--���5����Ʒ��Ч����С����Ŀ��Ч���ڻ���ʧЧ���ڴ�����ĿʧЧ����
select a.l_cont_id,
       a.c_cont_code,
       a.c_cont_name,
       a.l_effective_date,
       a.l_expiration_date,
       a.l_effective_flag,
       a.l_proj_id,
       b.l_effective_date,
       b.l_expiration_date
  from dataedw.dim_ic_contract a, dataedw.dim_pb_project_basic b
 where a.l_proj_id = b.l_proj_id
   and (a.l_effective_date < b.l_effective_date or
       a.l_expiration_date > b.l_expiration_date);

--�����ظ���¼
truncate table ttemp_invest_contract_0723;
drop table ttemp_invest_contract_0723;

create table ttemp_invest_contract_0723 as
select max(t.l_cont_id) as l_max_cont_id,min(t.l_cont_id) as l_min_cont_id,t.c_cont_code, t.l_effective_date
  from dim_ic_contract t --where (t.c_cont_code like 'CWTZ%' or t.c_cont_code like 'DK%')
 group by t.c_cont_code, t.l_effective_date
having count(*) = 2;

update dim_ic_contract t set t.l_expiration_date = 20991231,t.l_effective_flag = 1 where t.l_cont_id in (select s.l_min_cont_id from ttemp_invest_contract_0723 s);
delete from dim_ic_contract t where t.l_cont_id in (select s.l_max_cont_id from ttemp_invest_contract_0723 s);
delete from tt_ic_invest_cont_d t where t.l_cont_id in (select s.l_max_cont_id from ttemp_invest_contract_0723 s);
delete from tt_ic_invest_cont_m t where  t.l_cont_id in (select s.l_max_cont_id from ttemp_invest_contract_0723 s);

--����ʧЧ�����ظ��ļ�¼
create table ttemp_invest_contract_20991231 as
select a.c_cont_code,max(a.l_cont_id) as l_max_cont_id,min(a.l_cont_id) as l_min_cont_id
  from dim_ic_contract a
 where a.l_expiration_date = 20991231
 group by a.c_cont_code
having count(*) > 1;

delete from dim_ic_contract t where t.l_cont_id in (select t1.l_min_cont_id from ttemp_invest_contract_20991231 t1);
delete from tt_ic_invest_cont_d t where t.l_cont_id in (select t1.l_min_cont_id from ttemp_invest_contract_20991231 t1);
delete from tt_ic_invest_cont_m t where t.l_cont_id in (select t1.l_min_cont_id from ttemp_invest_contract_20991231 t1);

--�����Ч�׶��ص���
create table ttemp_invest_contract_conflict as 
select a.l_cont_id         as l_new_cont_id,
       a.c_cont_code,
       a.l_effective_date  as l_new_effective_date,
       a.l_expiration_date as l_new_expiration_date,
       b.l_cont_id         as l_old_cont_id,
       b.l_effective_date  as l_old_effective_date,
       b.l_expiration_date as l_old_expiration_date
  from dim_ic_contract a, dim_ic_contract b
 where a.c_cont_code = b.c_cont_code
   and a.l_effective_date < b.l_expiration_date
   and a.l_effective_flag = 1
   and b.l_effective_flag = 0;

delete from dim_ic_contract t where t.l_cont_id in (select t1.l_old_cont_id from ttemp_invest_contract_conflict t1);
delete from tt_ic_invest_cont_d t where t.l_cont_id in (select t1.l_old_cont_id from ttemp_invest_contract_conflict t1);
delete from tt_ic_invest_cont_m t where t.l_cont_id in (select t1.l_old_cont_id from ttemp_invest_contract_conflict t1);
