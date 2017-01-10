--�ʽ�������ϸ��
select * from(
with temp_invest as
 (select t1.l_cont_id,
         sum(t1.f_invest_agg) as f_invest_agg,
         sum(t1.f_return_agg) as f_return_agg,
         sum(t1.f_balance_agg) as f_balance_agg,
         sum(t1.f_income_agg) as f_income_agg
    from tt_ic_invest_cont_d t1
   where t1.l_day_id = 20161130
   group by t1.l_cont_id)
select b.c_proj_code as ��Ŀ����,
       b.c_name_full as ��Ŀ����,
       a.c_cont_code as ��ͬ����,
       a.c_cont_name as ��ͬ����,
       d.c_dept_name as ҵ����,
       c.c_manage_type_n as ����ְ��,
       c.c_proj_type_n as ��Ŀ����,
       c.c_func_type_n as ���ܷ���,
       e.f_balance_agg as Ͷ�����,
       e.f_return_agg as �ۼƻ���,
       a.l_begin_date as ��ͬ��ʼ��,
       a.l_expiry_date as ��ͬ��ֹ��,
       f.c_party_name as ���׶���,
       a.c_real_party as ʵ�ʽ��׶���,
       a.c_group_party as ���Ž��׶���,
       decode(b.f_trustpay_rate,null,null,to_char(b.f_trustpay_rate,'0.0000')) as ���б�����,
       a.c_invest_indus_n as �ʽ�ʵ��Ͷ��,
       g.c_area_name as ʵ���ʽ����õ�,
       a.f_cost_rate as Ͷ���ʳɱ�,
       a.l_xzhz_flag as �Ƿ���������,
       c.c_special_type_n as ����ҵ���ʶ,
       a.c_exit_way_n as �ʽ�ʵ����;���˳�,
       decode(a.l_invown_flag, 1, '��') as �Ƿ�Ͷ�ʹ�˾���в�Ʒ
  from dim_ic_contract      a,
       dim_pb_project_basic b,
       dim_pb_project_biz   c,
       dim_pb_department    d,
       temp_invest          e,
       dim_ic_counterparty  f,
       dim_pb_area          g 
  where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = c.l_proj_id
   and b.l_dept_id = d.l_dept_id
   and a.l_cont_id = e.l_cont_id(+)
   and a.l_party_id = f.l_party_id(+)
   and a.l_fduse_area = g.l_area_id(+)
   and a.l_effective_flag = 1) temp_am
--and a.c_real_party like '%������%'
--and b.l_proj_id = 1893
--and a.c_cont_code = 'DK11609C'
--order by b.l_setup_date desc, b.c_proj_code
union all
select * from (
with temp_fa as (select to2.l_proj_id,sum(to1.f_balance_agg) as f_balance_agg 
from tt_to_operating_book_d to1,dim_to_book to2 
where to1.l_book_id = to2.l_book_id 
and to2.l_effective_flag = 1 
and to1.l_day_id = 20161130
group by to2.l_proj_id)
select t1.c_proj_code as ��Ŀ���,
       t1.c_name_full as ��Ŀ����,
       null as ��ͬ����,
       null as ��ͬ����,
       t4.c_dept_name as ҵ����,
       t2.c_manage_type_n as ����ְ��,
       t2.c_proj_type_n as ��Ŀ����,
       t2.c_func_type_n as ���ܷ���,
       t3.f_balance_agg as Ͷ�����,
       null as �ۼƻ���,
       t1.l_setup_date as ��ͬ��ʼ��,
       t1.l_expiry_date as ��ͬ��ֹ��,
       null as ���׶���,
       null as ʵ�ʽ��׶���,
       null as ���Ž��׶���,
       decode(t1.f_trustpay_rate,
              null,
              null,
              to_char(t1.f_trustpay_rate, '0.0000')) as ��Ŀ���б�����,
       null as �ʽ�ʵ��Ͷ��,
       null as ʵ���ʽ����õ�,
       null as Ͷ���ʳɱ�,
       null as �Ƿ���������,
       t2.c_special_type_n as ����ҵ���ʶ,
       null as �ʽ�ʵ����;���˳�,
       null as �Ƿ�Ͷ�ʹ�˾���в�Ʒ
  from dim_pb_project_basic   t1,
       dim_pb_project_biz     t2,
       temp_fa t3,
       dim_pb_department      t4
 where t1.l_proj_id = t2.l_proj_id
   and (t2.l_pitch_flag = 1 or t2.c_special_type = 'A') --���ڳ���ҵ�������������Ŀ
   and t1.l_effective_flag = 1
   and t1.l_proj_id = t3.l_proj_id(+)
   and t1.l_dept_id = t4.l_dept_id) temp_xd;