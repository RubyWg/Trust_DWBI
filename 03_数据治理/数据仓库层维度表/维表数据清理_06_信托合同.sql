--���1����Ч�����ظ�
select a.c_cont_code,
       a.l_effective_date,
       max(a.l_cont_id) as l_max_id,
       min(a.l_cont_id) as l_min_id
  from dim_tc_contract a
 group by a.c_cont_code, a.l_effective_date
having count(*) > 1;

--���2��ʧЧ�����ظ�
select a.c_cont_code,
       a.l_expiration_date,
       max(a.l_cont_id) as l_max_id,
       min(a.l_cont_id) as l_min_id
  from dim_tc_contract a
 group by a.c_cont_code, a.l_expiration_date
having count(*) > 1;

--���3����ͬ��Ч���ڴ���ʧЧ����
select *
  from dataedw.dim_tc_contract a
 where a.l_effective_date >= a.l_expiration_date;


--���5����ͬ��Ч����С�ڲ�Ʒ��Ч���ڻ���ʧЧ���ڴ��ڲ�ƷʧЧ����
select a.l_cont_id,
       a.c_cont_code,
       a.c_cont_name,
       a.l_effective_date,
       a.l_expiration_date,
       a.l_effective_flag,
       a.l_prod_id,
       b.l_effective_date,
       b.l_expiration_date
  from dataedw.dim_tc_contract a, dataedw.dim_pb_product b
 where a.l_prod_id = b.l_prod_id
   and (a.l_effective_date < b.l_effective_date or
       a.l_expiration_date > b.l_expiration_date);

--step1��ɾ����ʱ��
truncate table temp_cont_repeat_20171123;
drop table temp_cont_repeat_20171123;


--step2�������仯ʱδ������Ч���ڣ������·��ص�
create table temp_cont_repeat_20171123 as 
select t.c_cont_code,
       t.l_effective_date,
       min(t.l_cont_id) as l_min_cont_id,
       max(t.l_cont_id) as l_max_cont_id,
       min(t.l_prod_id) as l_min_prod_id,
       max(t.l_prod_id) as l_max_prod_id,
       min(t.l_expiration_date) as l_min_expiration_id,
       max(t.l_expiration_date) as l_max_expiration_id
  from dim_tc_contract t where t.l_alltransfer_flag <> 1
 group by t.c_cont_code, t.l_effective_date
having count(*) = 2;

select * from temp_cont_repeat_20171123;

update dim_tc_contract t
   set t.l_effective_date =
       (select t1.l_min_expiration_id
          from temp_cont_repeat_20171123 t1
         where t.l_cont_id = t1.l_max_cont_id)
 where t.l_cont_id in
       (select t2.l_max_cont_id from temp_cont_repeat_20171123 t2);

--step3������Ȩ��ȫת�ú�ͬ���ּ�¼�ظ�
create table temp_transfer_cont_20171123 as 
select t.c_cont_code,
       t.l_expiration_date,
       min(t.l_cont_id) as l_min_cont_id,
       max(t.l_cont_id) as l_max_cont_id
  from dim_tc_contract t where t.l_alltransfer_flag = 1
 group by t.c_cont_code, t.l_expiration_date
having count(*) > 1;

select * from dim_tc_contract t where t.l_effective_date > t.l_expiration_date;

delete from dim_tc_contract a where a.rowid in (
select t.rowid
  from dim_tc_contract t, temp_transfer_cont_20171123 t1
 where t.c_cont_code = t1.c_cont_code
   and t.l_expiration_date = t1.l_expiration_date
   --and t.c_cont_code = '191077'
   and t.l_cont_id <> t1.l_min_cont_id);
   
--��Ч���ڴ���ʧЧ����
with temp_count as
 (select t.c_cont_code, count(*) as l_count
    from dim_tc_contract t
   group by t.c_cont_code)
select t1.l_count, t.*
  from dim_tc_contract t, temp_count t1
 where t.c_cont_code = t1.c_cont_code
   and t.l_effective_date > t.l_expiration_date
   and t.l_alltransfer_flag = 0;

update dim_tc_contract t
   set t.l_effective_date = t.l_begin_date
 where t.l_cont_id in (select t.l_cont_id
                         from dim_tc_contract t
                        where t.l_effective_date > t.l_expiration_date
                          and t.l_alltransfer_flag = 1);

select * from dim_tc_contract t where t.c_cont_code in( '257546','257478','246111');

--��ͬ��Ч�ҿ�ʼ����С����Ч����
select rowid,t.l_begin_date, t.l_effective_date, t.*
  from dim_tc_contract t
 where substr(t.l_begin_date, 1, 6) < substr(t.l_effective_date, 1, 6)
   and t.c_cont_code in (select t1.c_cont_code
                           from dim_tc_contract t1
                          group by t1.c_cont_code
                         having count(*) = 1);

