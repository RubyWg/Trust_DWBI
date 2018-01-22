create or replace view v_proj_zc as
with temp_a as (
select  c.l_proj_id,
     c.c_proj_code  c_proj_code,
  c.c_name_full  c_name_full,
  b.l_prod_id,
  h.c_dept_name  c_dept_abbr,
  f_isdate(c.l_setup_date)  l_setup_date,
  f_isdate(c.l_preexp_date)  l_preexp_date,
  f_isdate(c.l_expiry_date)  l_expiry_date,
  d.c_manage_type_n  c_manage_type_n,
  d.c_func_type_n  c_func_type_n,
  d.c_proj_type_n  c_proj_type_n,
  (case when d.l_pool_flag = 0 then '��' else '��' end) l_pool_flag,
  a.c_cont_code  c_cont_code,
  a.c_cont_no  c_cont_no,
  a.c_cont_name  c_cont_name,
  a.c_invest_indus_n  c_invest_indus_n,
  a.c_group_party  c_group_party,
  a.c_real_party  c_real_party,
  i.c_party_name,
  a.c_invest_way_n  c_invest_way_n,
  a.c_exit_way_n  c_exit_way_n,
  (case when a.l_xzhz_flag = 0 then '��' else '��' end)  l_xzhz_flag,
  g.c_indus_name  c_indus_name,
  e.c_city_name  c_city_name,
  e.c_prov_name  c_prov_name,
  a.f_cost_rate,
  (case when nvl(c.l_expiry_date,20991231) > 20161231 then '��' else '��' end) as c_is_end,
  f_isdate(c.l_expiry_date),
  sum(t.f_balance_agg)  f_agg,
  sum(t.f_invest_eot)   f_inc_eot,
  sum(t.f_return_agg)  f_dec_agg
from  tt_ic_invest_cont_m  t
  join  dim_ic_contract  a
    on   t.l_cont_id = a.l_cont_id
  join  dim_pb_product  b
    on   a.l_prod_id = b.l_prod_id
  join  dim_pb_project_basic  c
    on   b.l_proj_id = c.l_proj_id
  join  dim_pb_project_biz  d
    on   b.l_proj_id = d.l_proj_id
  join  dim_pb_area  e
    on   a.l_fduse_area = e.l_area_id
  join  dim_month  f
    on   t.l_month_id = f.month_id
  left outer join  dim_pb_industry  g
    on   a.l_invindus_id = g.l_indus_id
  join  dim_pb_department  h
    on   c.l_dept_id = h.l_dept_id
  left outer join dim_ic_counterparty i
    on   a.l_party_id = i.l_party_id
where  f.year_id in (2016)
 and f.month_of_year in (12)
 and substr(a.l_effective_date, 1, 6) <=  t.l_month_id
 and substr(a.l_expiration_date, 1, 6) > t.l_month_id
group by  c.c_proj_code, c.l_proj_id,
  c.c_name_full,
  b.l_prod_id,
  h.c_dept_name,
  c.l_setup_date,
  c.l_preexp_date,
  c.l_expiry_date,
  d.c_manage_type_n,
  d.c_func_type_n,
  d.c_proj_type_n,
  d.l_pool_flag,
  a.c_cont_code,
  a.c_cont_no,
  a.c_cont_name,
  a.c_invest_indus_n,
  a.c_group_party,
  a.c_real_party,
  i.c_party_name,
  a.c_invest_way_n,
  a.c_exit_way_n,
  a.l_xzhz_flag,
  g.c_indus_name,
  e.c_city_name,
  e.c_prov_name,
  a.f_cost_rate),
temp_fa as (
select distinct t1.l_prod_id, t1.fa_balance, t1.tz_balance, (case when nvl(t1.tz_balance,0) - nvl(t2.ta_balance,0) = 0 then '��' else '��' end) as f_equal
  from (
select b.l_prod_id, sum(case when c.c_subj_code_l1 = '4001' and c.c_subj_code_l2 <> '400100' then t.f_balance_agg else 0 end) as fa_balance,
       sum(case when c.c_subj_code_l1 in ('1101','1111','1303','1501','1503','1531','1541','1122') then t.f_balance_agg else 0 end) as tz_balance
  from tt_to_accounting_subj_m t, dim_to_book a, dim_pb_product b, dim_to_subject c
 where t.l_book_id = a.l_book_id and a.l_prod_id = b.l_prod_id and t.l_subj_id = c.l_subj_id
   and t.l_month_id = 201612
 group by b.l_prod_id) t1, (select a.l_prod_id, sum(a.f_agg) over(partition by a.l_proj_id) as ta_balance from temp_a a) t2
 where t1.l_prod_id = t2.l_prod_id
  )

select  c.c_book_code ��Ŀ������,
  a.c_proj_code  ��Ŀ����,
  a.c_name_full  ��Ŀ����,
  b.l_prod_id,
  a.c_dept_abbr  ��������,
  a.l_setup_date  ��Ŀ������,
  a.l_preexp_date  ��ĿԤ�Ƶ�����,
  a.l_expiry_date  ��Ŀ������,
  a.c_manage_type_n  ����ʽ,
  a.c_func_type_n  ���ܷ���,
  a.c_proj_type_n  ��Ŀ����,
  a.l_pool_flag �Ƿ��ʽ��,
  a.c_cont_code ��ͬ����,
  a.c_cont_no ��ͬ���,
  a.c_cont_name ��ͬ����,
  a.c_invest_indus_n ��ͬ��ҵͶ��,
  a.c_group_party ���Ž��׶���,
  a.c_real_party ʵ�ʽ��׶���,
  a.c_party_name ��ͬ���׶���,
  a.c_invest_way_n  Ͷ�ʷ�ʽ,
  a.c_exit_way_n �ʽ���;,
  a.l_xzhz_flag  �Ƿ�������,
  a.c_indus_name ��ҵ����,
  a.c_city_name �ʽ����ó���,
  a.c_prov_name �ʽ�����ʡ��,
  a.f_cost_rate ���ʳɱ�,
  a.c_is_end as �Ƿ�����,
  b.fa_balance faʵ�����д�����ģ,
  b.tz_balance faͶ�ʺ�ͬ��ģ,
  b.f_equal Ͷ�ʹ�ģ�Ƿ�һ��,
  a.f_agg Ͷ�ʺ�ͬ��ģ,
  a.f_inc_eot ��������Ͷ�ʹ�ģ,
  a.f_dec_agg �ۼƻ���,
  row_number() over(partition by a.c_proj_code order by a.c_cont_code) as rn
 from temp_a a
 left join temp_fa b on a.l_prod_id = b.l_prod_id
 left join dim_to_book c on a.l_prod_id = c.l_prod_id
 order by a.l_setup_date, a.c_proj_code, c.c_book_code, a.c_cont_no;
