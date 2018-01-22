--�����Ա��
select count(*) from tcr_member a where a.d_create_time <=to_date('20151231','YYYYMMDD') and a.c_deal_status = '1';

--��ǰ��Ա��
select * from tcr_member;
select count(*) from tcr_member a where a.c_deal_status = '1' and a.d_deal_time < to_date('20160601','YYYYMMDD');

--��Ա����
select a.c_cust_level,a.c_cust_level_n, count(*)
  from tcr_customer a
 group by a.c_cust_level,a.c_cust_level_n
 order by a.c_cust_level;

--��Ա�ͻ�����
select a.c_cust_type_n, count(*)
  from tcr_customer a, tcr_member b
 where a.c_cust_code = b.c_cust_code and b.c_deal_status = '1'
 group by a.c_cust_type_n;
 
--�ͻ�״̬
select a.c_cust_status_n as �ͻ�״̬,
       count(*) ��ǰ��Ա��,
       sum(case
             when b.d_create_time <= to_date('20151231', 'YYYYMMDD') then
              1
             else
              0
           end) as �����Ա��
  from tcr_customer a, tcr_member b
 where a.c_cust_code = b.c_cust_code and b.c_deal_status = '1'
 group by a.c_cust_status_n;
 
--ÿ�»�Ա��������
select to_char(a.d_create_time, 'YYYYMM'), count(*)
  from tcr_member a
 where a.d_create_time >= to_date('20160101', 'YYYYMMDD')
 group by to_char(a.d_create_time, 'YYYYMM')
 order by to_char(a.d_create_time, 'YYYYMM');
 
--�ͻ������ϸ��
with temp_emp as
 (select t1.c_emp_code, t1.c_emp_name, t2.c_dept_name
    from tde_employee t1, tde_department t2
   where t1.c_dept_id = t2.c_dept_id),
temp_share as
 (select t.c_cust_code, sum(t.f_share) / 10000 as f_share
    from tta_share t
   where t.d_confirm <= to_date('20160531', 'yyyymmdd')
   group by t.c_cust_code)
select a.c_cust_code    as �ͻ�����,
       a.c_cust_name    as �ͻ�����,
       a.c_cust_class_n as �ͻ����,
       a.c_cust_type_n  as �ͻ�����,
       a.c_broker_code  as �ͻ��������,
       c.c_emp_code     as Ա������,
       c.c_broker_name  as �ͻ���������,
       d.c_dept_name    as ��������,
       b.c_member_code  as ��Ա����,
       b.d_deal_time    as ��Ա���ͨ������,
       e.f_share        as �ݶ�
  from tcr_customer a
  left outer join tcr_member b
    on a.c_cust_code = b.c_cust_code
  left outer join tcr_broker c
    on a.c_broker_code = c.c_broker_code
  left outer join temp_emp d
    on c.c_emp_code = d.c_emp_code
  left outer join temp_share e
    on a.c_cust_code = e.c_cust_code
 where nvl(a.d_create_time, to_date('20160101', 'YYYYMMDD')) <
       to_date('20160601', 'YYYYMMDD')
   and b.d_deal_time < to_date('20160601', 'YYYYMMDD')
 order by a.c_cust_class_n, a.c_cust_type_n;
    
