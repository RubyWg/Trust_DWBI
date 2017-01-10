--��Ŀ�ؼ�Ҫ��
select b.c_proj_code, --��Ŀ����
       b.c_proj_name, --��Ŀ����
       b.l_setup_date, --��������
       b.l_expiry_date, --��ֹ����
       a.c_proj_type, --��Ŀ����
       a.c_proj_type_n, --��Ŀ����˵��
       a.c_func_type, --���ܷ���
       a.c_func_type_n, --���ܷ���˵��
       a.c_affair_props, --��������
       a.c_affair_props_n, --��������˵��
       c.c_inst_name --�Ƽ�����
  from dim_pb_project_biz a, dim_pb_project_basic b, dim_pb_institution c
 where a.l_Proj_id = b.l_proj_id
   and a.l_bankrec_sub = c.l_inst_id(+)
   and b.l_effective_flag = 1
   and nvl(b.l_expiry_date, '20991231') > 20151231
 order by b.c_proj_code, a.l_proj_id;

--��Ŀ�Ƽ�����
select c.c_proj_code, c.c_proj_name, b.c_inst_name
  from dim_pb_project_basic c, dim_pb_project_biz a, dim_pb_institution b
 where a.l_proj_id = c.l_proj_id
   and a.l_bankrec_sub = l_inst_Id
   and nvl(C.L_EXPIRY_DATE, '20991231') < 20160601
   and a.l_effective_flag = 1;

--�鿴������Ŀ�Ĵ�����ģ��Ӧ��ί����
select c.c_cust_name, b.l_proj_id, c.c_cust_tytpe_n, sum(a.f_scale)
  from tt_tc_scale_flow_d   a,
       dim_tc_contract      b,
       dim_ca_customer      c,
       dim_pb_project_basic d
 where a.l_cont_id = b.l_cont_id
   and b.l_settler_id = c.l_cust_id
   and b.l_proj_id = d.l_proj_Id
   and d.l_effective_flag = 1
   and d.c_proj_name like '%�Ƚ�1167��%'
 group by c.c_cust_name, b.l_proj_id, c.c_cust_tytpe_n
having sum(a.f_scale) <> 0
 order by c.c_cust_tytpe_n;
 
--������Ŀ����
select b.c_proj_type_n, count(*)
  from dim_pb_project_basic a, dim_pb_project_biz b
 where a.l_effective_flag = 1
   and a.l_proj_id = b.l_proj_id
   and a.c_proj_phase >= '35'
   and nvl(a.l_expiry_date, 20991231) > 20160930
   and a.l_setup_date <= 20160930
 group by b.c_proj_type_n;
 
select t.c_object_code
  from tt_pb_object_status_m t, dim_pb_object_status s
 where t.l_month_id = 201609
   and t.l_objstatus_id = s.l_objstatus_id and t.c_object_type = 'XM'
   and s.l_exist_tm_flag = 1;

--������Ŀ��ģ
select c.c_proj_type_n, round(sum(a.f_balance_agg) / 100000000, 2)
  from tt_tc_scale_cont_m   a,
       dim_tc_contract      d,
       dim_pb_project_basic b,
       dim_pb_project_biz   c
 where a.l_proj_id = b.l_proj_id
   and a.l_cont_id = d.l_cont_id
   and b.l_proj_id = c.l_proj_id
   /*and substr(d.l_effective_date, 1, 6) <= 201609
   and substr(d.l_expiration_date, 1, 6) > 201609*/
      --and nvl(b.l_expiry_date, 20991231) > 20160930
   and a.l_month_id = 201609
 group by c.c_proj_type_n;

--���ʽ����Ŀ
select c.c_dept_name,a.l_proj_id,a.c_proj_code,a.c_proj_name
  from dim_pb_project_basic a, dim_pb_project_biz b, dim_pb_department c
 where a.l_proj_id = b.l_proj_id
   and a.l_dept_id = c.l_dept_id
   and b.l_pool_flag = 1
   and a.l_effective_flag = 1;

select * from tt_tc_scale_cont_m t where t.l_month_id = 201609 and t.l_proj_id = 1499;

--�ʹ���Ŀ����
select distinct a.c_proj_code,a.c_proj_name,c.c_invest_type_n
  from dim_pb_project_basic a, dim_pb_department b, dim_to_book c
 where a.l_dept_id = b.l_dept_id
   and a.l_proj_id = c.l_proj_id
   and c.l_effective_flag = 1
   and b.c_dept_name like '%�ʲ�����%';

--������Ŀ����
select b.c_proj_type_n, count(*)
  from dim_pb_project_basic a, dim_pb_project_biz b
 where a.l_effective_flag = 1
   and a.l_proj_id = b.l_proj_id
   and a.c_proj_phase >= '35'
   and nvl(a.l_setup_date, 20991231) between 20160901 and 20160930
 group by b.c_proj_type_n;
 
select t.c_object_code
  from tt_pb_object_status_m t, dim_pb_object_status s
 where t.l_month_id = 201609
   and t.l_objstatus_id = s.l_objstatus_id and t.c_object_type = 'XM'
   and s.l_setup_tm_flag = 1;
 
--������Ŀ��ģ���ų����ʽ����Ŀ
select c.c_proj_type_n, round(sum(a.f_increase_tot) / 100000000, 2)
  from tt_tc_scale_cont_m   a,
       dim_tc_contract      d,
       dim_pb_product       e,
       dim_pb_project_basic b,
       dim_pb_project_biz   c
 where a.l_proj_id = b.l_proj_id
   and a.l_cont_id = d.l_cont_id
   and a.l_prod_id = e.l_prod_id
   and b.l_proj_id = c.l_proj_id
   and substr(d.l_effective_date, 1, 6) <= 201609
   and substr(d.l_expiration_date, 1, 6) > 201609
   and e.l_setup_date between 20160101 and 20160930
   and c.l_pool_flag = 0
 --and nvl(b.l_expiry_date, 20991231) > 20160930
   and a.l_month_id = 201609
 group by c.c_proj_type_n;

--������Ŀ����
select b.c_proj_type_n, count(*)
  from dim_pb_project_basic a, dim_pb_project_biz b
 where a.l_effective_flag = 1
   and a.l_proj_id = b.l_proj_id
   and nvl(a.l_expiry_date, 20991231) between 20160901 and 20160930
 group by b.c_proj_type_n;
 
select t.c_object_code
  from tt_pb_object_status_m t, dim_pb_object_status s
 where t.l_month_id = 201609
   and t.l_objstatus_id = s.l_objstatus_id and t.c_object_type = 'XM'
   and s.l_expiry_tm_flag = 1;

--������Ŀ��ģ
select c.c_proj_type_n, round(sum(a.f_decrease_tot) / 100000000, 2)
  from tt_tc_scale_cont_m   a,
       dim_tc_contract      d,
       dim_pb_product       e,
       dim_pb_project_basic b,
       dim_pb_project_biz   c
 where a.l_proj_id = b.l_proj_id
   and a.l_cont_id = d.l_cont_id
   and a.l_prod_id = e.l_prod_id
   and b.l_proj_id = c.l_proj_id
   and substr(d.l_effective_date, 1, 6) <= 201609
   and substr(d.l_expiration_date, 1, 6) > 201609
   and nvl(b.l_expiry_date, 20991231) between 20160901 and 20160930
 --and nvl(b.l_expiry_date, 20991231) > 20160930
   and a.l_month_id = 201609
 group by c.c_proj_type_n;
 
 
--��ͬ����
select c.c_proj_type_n,
       round(sum(a.f_planned_agg) / 100000000, 2) as ��ͬ����,
       round(sum(a.f_planned_agg - a.f_actual_agg) / 100000000, 2) as δ����,
       round(sum(a.f_actual_eot) / 100000000, 2) as ����ʵ��
  from tt_ic_ie_prod_m a, dim_pb_project_basic b, dim_pb_project_biz c,dim_pb_ie_type d ,dim_pb_ie_status e
 where a.l_month_id = 201609
   and a.l_proj_id = b.l_proj_id
   and b.l_proj_id = c.l_proj_id
   and a.l_ietype_id = d.l_ietype_id
   and d.c_ietype_code_l1 = 'XTSR'
   and a.l_iestatus_id = e.l_iestatus_id and e.c_iestatus_code = 'NEW'
   and substr(b.l_effective_date, 1, 6) <= 201609
   and substr(b.l_expiration_date, 1, 6) > 201609
 group by c.c_proj_type_n;

--δ�����ͬ����
select f.c_proj_type_n,
       round(sum(c.f_planned_agg +
                 decode(e.c_ietype_code_l2, 'XTCGF', c.f_actual_agg, 0)) /
             100000000,
             2) as ��ͬ����
/*round(sum(decode(e.c_ietype_code_l2, 'XTCGF', c.f_actual_agg, 0)) /
10000,
2) as ��ͬ�ƹ˷�*/
  from tt_ic_ie_party_m     c,
       dim_pb_project_basic d,
       dim_pb_ie_type       e,
       dim_pb_project_biz   f
 where c.l_proj_id = d.l_proj_id
   and c.l_month_id = 201609
   and c.l_ietype_id = e.l_ietype_id
   and e.c_ietype_code_l1 = 'XTSR'
   and c.l_proj_id = d.l_proj_id
   and d.l_proj_id = f.l_proj_id
   and substr(d.l_effective_date, 1, 6) <= 201609
   and substr(d.l_expiration_date, 1, 6) > 201609
   and nvl(d.l_expiry_date, 20991231) > 20160930
 group by f.c_proj_type_n;

/********************************************************************************************************************************************/
--�ʽ���Դ��ϸ�ױ�
with temp_prod_scale as
 (select t.l_prod_id,
         sum(t.f_balance_agg) as f_balance_agg,
         sum(t.f_decrease_agg) as f_decrease_agg
    from tt_tc_scale_cont_m t, dim_pb_product t1
   where t.l_month_id = 201610
     and t.l_prod_id = t1.l_prod_id --and t1.l_prod_id = 1102
     and substr(t1.l_effective_date, 1, 6) <= t.l_month_id
     and substr(t1.l_expiration_date, 1, 6) > t.l_month_id
     --and t1.c_prod_code = 'ZH08NN'
   group by t.l_prod_id),
temp_prod_revenue as
 (select t.l_prod_id,
         nvl(sum(decode(t1.c_ietype_code_l2, 'XTBC', t.f_actual_agg, 0)), 0) as f_actual_xtbc, --�ۼ���֧�����б���
         nvl(sum(decode(t1.c_ietype_code_l2, 'XTCGF', t.f_actual_eot, 0)), 0) as f_actual_xtcgf, --������֧�����вƹ˷�
         nvl(sum(decode(t1.c_ietype_code_l2, 'XTBC', t.f_planned_agg, 0)), 0) as f_planned_xtbc, --�ۼƼƻ����б���
         nvl(sum(decode(t1.c_ietype_code_l2, 'XTCGF', t.f_planned_agg, 0)),
             0) as f_planned_xtcgf --�ۼƼƻ��ƹ˷�
    from tt_ic_ie_prod_m t, dim_pb_ie_type t1
   where t.l_month_id = 201610
     and t.l_ietype_id = t1.l_ietype_id
   group by t.l_prod_id),
temp_benefical_right as
 (select t.l_prod_id,
         min(t.f_expect_field) as f_min_field,
         max(t.f_expect_field) as f_max_field
    from dim_tc_beneficial_right t
   group by t.l_prod_id),
temp_sale_way as
 (select t.l_prod_id, wmsys.wm_concat(distinct t.c_sale_way_n) as c_sale_way
    from dim_tc_contract t
   where substr(t.l_effective_date, 1, 6) <= 201610
     and substr(t.l_expiration_date, 1, 6) > 201610
   group by t.l_prod_id),
temp_ic_rate as
 (select t.l_prod_id,
         min(t.f_rate) as f_min_rate,
         max(t.f_rate) as f_max_rate
    from dim_ic_rate t
   group by t.l_prod_id)
select l.c_book_code as ���ױ��,
       b.c_proj_code as ��Ŀ���,
       b.c_proj_name as ��Ŀ����,
       a.c_prod_code as ��Ʒ����,
       d.c_dept_name as ҵ����,
       c.c_manage_type_n as ��������,
       c.c_proj_type_n as ��Ŀ����,
       c.c_func_type_n as ���ܷ���,
       nvl(e.f_balance_agg, 0) as ��Ʒ�������,
       null as FA��ģ,
       null as Ͷ�����,
       nvl(decode(c.l_pool_flag, 1, 0, e.f_decrease_agg), 0) as �ۼƻ���, --���ʽ����Ŀ��ͳ��
       nvl(decode(a.c_struct_type, '0', e.f_balance_agg, 0), 0) as ����,
       nvl(decode(a.c_struct_type, '2', e.f_balance_agg, 0), 0) as �Ӻ�,
       decode(c.l_pool_flag, 1, b.l_setup_date, a.l_setup_date) ��Ʒ��ʼ����, --���ʽ��ȡ��Ŀ��������
       decode(c.l_pool_flag, 1, b.l_expiry_date, a.l_expiry_date) ��Ʒ��ֹ����, --���ʽ����Ŀ�f��Ŀ��ֹ����
       to_char(k.f_min_rate,'0.0000') || '-' || to_char(k.f_max_rate,'0.0000') as ��Ʒ���б�����,
       (f.f_actual_xtbc + f.f_actual_xtcgf + f.f_planned_xtbc +
       f.f_planned_xtcgf) as ��ͬ������,
       (f.f_actual_xtbc + f.f_planned_xtbc) as ���б���,
       f.f_actual_xtbc as �ۼ���֧�����б���,
       f.f_planned_xtbc as ��δ֧�����б���,
       f.f_actual_xtcgf as �ۼ���֧��������ʷ�,
       f.f_planned_xtcgf as ��δ֧��������ʷ�,
       c.c_invest_indus_n as ��Ŀʵ��Ͷ��,
       null as ��ͬ�����˵�һ,
       g.c_inst_name as ʵ���ʽ���Դ,
       j.c_sale_way as �����ʽ���������,
       a.c_special_settlor as ������Ŀ����ί����,
       to_char(i.f_min_field,'0.0000') || '-' || to_char(i.f_max_field,'0.0000') as ��ƷԤ��������,
       case
         when nvl(b.l_expiry_date, 20991231) > 20160930 then
          '����'
         else
          '����'
       end as �Ƿ�����,
       decode(a.l_tot_flag, 1, '��') as �Ƿ�TOT
  from dim_pb_product       a,
       dim_pb_project_basic b,
       dim_pb_project_biz   c,
       dim_pb_department    d,
       temp_prod_scale      e,
       temp_prod_revenue    f,
       dim_pb_institution   g,
       temp_benefical_right i,
       temp_sale_way        j,
       temp_ic_rate         k ,
       dim_to_book          l
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = c.l_proj_id
   and b.l_dept_id = d.l_dept_id(+)
   and c.l_bankrec_ho = g.l_inst_id(+)
   and a.l_prod_id = e.l_prod_id(+)
   and a.l_prod_id = f.l_prod_id(+)
   and a.l_prod_id = i.l_prod_id(+)
   and a.l_prod_id = j.l_prod_id(+)
   and a.l_prod_id = k.l_prod_id(+)
   --and b.c_proj_code = 'AVICTC2016X0247'
   and a.l_prod_id = l.l_prod_id(+)
   and substr(a.l_effective_date, 1, 6) <= 201610
   and substr(a.l_expiration_date, 1, 6) > 201610
 order by b.l_setup_date, b.c_proj_code, a.c_prod_code;

/********************************************************************************************************************************************/
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

--��
--�ʽ�������ϸ�ױ�
with temp_rate as
 (select t.l_proj_id,
         min(t.f_rate) as f_min_rate,
         max(t.f_rate) as f_max_rate
    from dim_ic_rate t
   where t.l_ietype_id = 2
   group by t.l_proj_id)
select b.c_proj_code as ��Ŀ���,
       b.c_proj_name as ��Ŀ����,
       a.c_cont_code as ��ͬ����,
       a.c_cont_name as ��ͬ����,
       d.c_dept_name as ҵ����,
       c.c_manage_type_n as ����ְ��,
       c.c_proj_type_n as ��Ŀ����,
       c.c_func_type_n as ���ܷ���,
       g.f_balance_agg as Ͷ�������,
       g.f_return_agg as �ۼƻ���,
       a.l_begin_date as ��ͬ��ʼ��,
       a.l_expiry_date as ��ͬ��ֹ��,
       a.l_expiry_date as ��ͬ������ֹ��,
       h.f_min_rate || '-' || h.f_max_rate as ��Ŀ���б�����,
       a.c_invest_indus_n as �ʽ�ʵ��Ͷ��,
       e.c_party_name as ʵ�ʽ��׶���,
       f.c_area_name as ʵ���ʽ����õ�,
       a.f_cost_rate as Ͷ���ʳɱ�,
       a.l_xzhz_flag as �Ƿ���������,
       c.c_special_type_n as ����ҵ���ʶ,
       a.c_exit_way_n as �ʽ�ʵ����;���˳�,
       a.l_invown_flag as �Ƿ�Ͷ�ʹ�˾���в�Ʒ
  from dim_ic_contract      a,
       dim_pb_project_basic b,
       dim_pb_project_biz   c,
       dim_pb_department    d,
       dim_ic_counterparty  e,
       dim_pb_area          f,
       tt_ic_invest_cont_d  g,
       temp_rate            h
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = c.l_proj_id
   and b.l_dept_id = d.l_dept_id
   and a.l_party_id = e.l_party_id
   and a.l_fduse_area = f.l_area_id
   and a.l_cont_id = g.l_cont_id
   and b.l_proj_id = h.l_proj_id(+)
   and g.l_day_id = 20160831
   and a.l_effective_flag = 1
union all
select t1.c_proj_code as ��Ŀ���,
       t1.c_proj_name as ��Ŀ����,
       null as ��ͬ����,
       null as ��ͬ����,
       t4.c_dept_name as ҵ����,
       t2.c_manage_type_n as ����ְ��,
       t2.c_proj_type_n as ��Ŀ����,
       t2.c_func_type_n as ���ܷ���,
       t3.f_scale_eot as Ͷ�������,
       null as �ۼƻ���,
       t1.l_setup_date as ��ͬ��ʼ��,
       t1.l_expiry_date as ��ͬ��ֹ��,
       null as ��ͬ������ֹ��,
       null as ��Ŀ���б�����,
       null as �ʽ�ʵ��Ͷ��,
       null as ʵ�ʽ��׶���,
       null as ʵ���ʽ����õ�,
       null as Ͷ���ʳɱ�,
       null as �Ƿ���������,
       t2.c_special_type_n as ����ҵ���ʶ,
       null as �ʽ�ʵ����;���˳�,
       null as �Ƿ�Ͷ�ʹ�˾���в�Ʒ
  from dim_pb_project_basic t1, dim_pb_project_biz t2,tt_po_rate_proj_d t3,dim_pb_department t4
 where t1.l_proj_id = t2.l_proj_id
   and t2.l_pitch_flag = 1--���ڳ���ҵ��
   and t1.l_effective_flag = 1
   and t1.l_proj_id = t3.l_proj_id(+)
   and t3.l_day_id = 20160930
   and t1.l_dept_id = t4.l_dept_id;

--�Ƿ��ڳ���ҵ��
select b.l_pitch_flag,a.* from dim_pb_project_basic a,dim_pb_project_biz b where a.l_proj_id = b.l_proj_id and a.c_proj_code = 'AVICTC2014X0641';

--TA��FA��AM��ģ�Ƚ�
with temp_ta as
 (select a.l_proj_id,
         sum(a.f_balance_agg) as f_ta
    from tt_tc_scale_cont_m a, dim_pb_product b
   where a.l_prod_id = b.l_prod_id
     and a.l_month_id = 201610
     and substr(b.l_effective_date, 1, 6) <= 201610
     and substr(b.l_expiration_date, 1, 6) > 201610
   group by a.l_proj_id),
temp_fa as
 (select c.l_proj_id,
         sum(c.f_balance_agg) as f_fa
    from tt_to_operating_book_m c,dim_to_book c1
   where c.l_month_id = 201610 
     and c.l_book_id = c1.l_book_id
     and c1.l_effective_flag = 1
   group by c.l_proj_id),
temp_am as
 (select a.l_proj_id,
         sum(a.f_invest_agg) - sum(a.f_return_agg) as f_am
    from tt_ic_invest_cont_m a, dim_ic_contract b
   where a.l_cont_id = b.l_cont_id
     and substr(b.l_effective_date, 1, 6) <= 201610
     and substr(b.l_expiration_date, 1, 6) > 201610
     and a.l_month_id = 201610
   group by a.l_proj_id)
select t.l_proj_id,t.c_proj_code,t.c_proj_name,t.l_setup_date,temp_ta.f_ta, temp_fa.f_fa, temp_am.f_am
  from dim_pb_project_basic t,temp_ta, temp_fa, temp_am
 where t.l_proj_id = temp_ta.l_proj_id 
   and temp_ta.l_proj_id = temp_fa.l_proj_id(+)
   and temp_ta.l_proj_id = temp_am.l_proj_id(+);
--and (temp_ta.f_ta <> temp_fa.f_fa or temp_ta.f_ta <> temp_am.f_am);

select t1.c_proj_code   as ��Ŀ����,
       t1.c_proj_name   as ��Ŀ����,
       t1.l_setup_date  as ��������,
       t1.f_balance_eot as TA��ģ,
       t2.f_scale_eot   as FA��ģ,
       t2.c_proj_code   as ��Ŀ����,
       t2.c_proj_name   as ��Ŀ����
  from (select b.l_proj_id,b.c_proj_code,b.c_proj_name,b.l_setup_date,a.f_balance_eot
           from tt_sr_scale_proj_m a, dim_pb_project_basic b
          where a.l_proj_id = b.l_proj_id
            and a.l_month_id = 201610
            and substr(b.l_effective_date, 1, 6) <= 201610
            and substr(b.l_expiration_date, 1, 6) > 201610) t1 full outer join
        (select d.l_proj_id,d.c_proj_code,d.c_proj_name,d.l_setup_date,c.f_scale_eot
           from tt_po_rate_proj_d c, dim_pb_project_basic d
          where c.l_proj_id = d.l_proj_id
            and c.l_day_id = 20161031) t2 on t1.l_proj_id = t2.l_proj_id 
  where t1.f_balance_eot <> t2.f_scale_eot
order by t1.l_setup_date;

--AMͶ�����
select b.c_proj_code,
       b.c_proj_name,
       sum(a.f_invest_agg),
       sum(a.f_return_agg),
       sum(a.f_invest_agg) - sum(a.f_return_agg) as Ͷ�����
  from tt_ic_invest_cont_m a, dim_pb_project_basic b,dim_ic_contract c
 where a.l_proj_id = b.l_proj_id
   and a.l_month_id = 201610
   and b.c_proj_code = 'AVICTC2015X1176'
 group by b.c_proj_code, b.c_proj_name;

--AMͶ�����
select a.*
  from tt_ic_invest_cont_m a, dim_pb_project_basic b
 where a.l_proj_id = b.l_proj_id
   and a.l_month_id = 201610
   and b.c_proj_code = 'AVICTC2015X1176';
   
--����ҵ�����룬������״̬
select b.c_proj_code,
       /*a.l_revtype_id,
       A.L_REVSTATUS_ID,*/
       sum(a.f_actual_eot),
       sum(a.f_actual_agg),
       sum(a.f_actual_agg+a.f_planned_agg)
  from tt_sr_tstrev_proj_m a, dim_pb_project_basic b
 where a.l_proj_id = b.l_proj_id
   and a.l_month_id >= substr(b.l_effective_date, 1, 6)
   and a.l_month_id < substr(b.l_expiration_date, 1, 6) and a.l_revtype_id = 2
   and a.l_month_id = 201609 --and b.c_proj_code = 'AVICTC2014X0232'
 group by b.c_proj_code/*, a.l_revtype_id, A.L_REVSTATUS_ID*/;

select * from dim_sr_revenue_type;
select * from dim_pb_project_basic t where t.c_proj_code = 'AVICTC2014X0232';
select * from tt_sr_revenue_flow_d t where t.l_stage_id  = 3473;

--��Ʒ��������
select b.c_stage_code,
       /*a.l_revtype_id,
       A.L_REVSTATUS_ID,*/
       sum(a.f_actual_eot) as ������������,
       sum(a.f_actual_agg) as �ۼ���������,
       sum(a.f_actual_agg + a.f_planned_agg) as ��ͬ������
  from tt_sr_tstrev_stage_m a, dim_sr_stage b
 where a.l_stage_id = b.l_stage_id
   and a.l_month_id >= substr(b.l_effective_date, 1, 6)
   and a.l_month_id < substr(b.l_expiration_date, 1, 6)
   and a.l_month_id = 201609 --and b.c_proj_code = 'AVICTC2014X0232'
 group by b.c_stage_code /*, a.l_revtype_id, A.L_REVSTATUS_ID*/
having sum(a.f_actual_agg + a.f_planned_agg) <> 0;

--��Ӫ���
select null as ���ױ��,
       a.c_cont_code as ��ͬ����,
       a.c_cont_no as ��ͬ���,
       c.c_proj_name as ��Ŀ����,
       d.c_dept_name as ��������,
       f.c_manage_type_n as ��/����,
       e.f_balance_agg   as �������,
       e.f_decrease_agg  as �ۼƻ���,
       decode(b.c_struct_type,'0',e.f_balance_agg,null ) as ����,
       decode(b.c_struct_type,'2',e.f_balance_agg,null ) as �Ӻ�,
       a.l_sign_date as ��ͬ���ʱ��,
       a.l_expiry_date as ��ͬ��ֹʱ��,
       null as ʵ�����б�����,
       null as ��ͬ������,
       null as ����Ӧ��������,
       null as ��δ��������,
       null as ���б�������,
       null as ��ͬ�����������
  from dim_tc_contract      a,
       dim_pb_product       b,
       dim_pb_project_basic c,
       dim_pb_department    d,
       tt_tc_scale_cont_m   e,
       dim_pb_project_biz   f
 where a.l_prod_id = b.l_prod_id
   and b.l_proj_id = c.l_proj_id
   and c.l_dept_id = d.l_dept_id
   and a.l_cont_id = e.l_cont_id
   and b.l_proj_id = f.l_proj_id
   and substr(a.l_effective_date, 1, 6) <= e.l_month_id
   and substr(a.l_expiry_date, 1, 6) > e.l_month_id
   and e.l_month_id = 201609;

--����
select c.c_proj_code as ��Ŀ����,
       c.c_proj_name as ��Ŀ����,
       b.c_stage_code as ��Ʒ����,
       b.l_setup_date as ��Ʒ��������,
       b.l_expiry_date as ��Ʒ��������,
       b.c_stage_name as ��Ʒ����,
       d.c_dept_name as ��������,
       sum(decode(a.l_revtype_id, 2, a.f_actual_agg, 0)) as �ۼ���֧�����б���,
       sum(decode(a.l_revtype_id, 2, a.f_actual_eot, 0)) as ������֧�����б���,
       sum(decode(a.l_revtype_id, 2, a.f_planned_agg, 0)) as �ۼ�δ֧�����б���,
       sum(decode(a.l_revtype_id, 4, a.f_actual_agg, 0)) as �ۼ���֧���ƹ˷�,
       sum(decode(a.l_revtype_id, 4, a.f_actual_eot, 0)) as ������֧���ƹ˷�,
       sum(decode(a.l_revtype_id, 4, a.f_planned_agg, 0)) as �ۼ�δ֧���ƹ˷�
  from tt_sr_tstrev_stage_m a,
       dim_sr_stage         b,
       dim_pb_project_basic c,
       dim_pb_department    d
 where a.l_stage_id = b.l_stage_id
   and b.l_proj_id = c.l_proj_id
   and c.l_dept_id = d.l_dept_id
   and substr(c.l_effective_date, 1, 6) <= 201608
   and substr(c.l_expiration_date, 1, 6) > 201608
   and a.l_month_id = 201608
 group by c.c_proj_code,
          c.c_proj_name,
          b.c_stage_code,
          b.c_stage_name,
          b.l_setup_date,
          b.l_expiry_date,
          d.c_dept_name
having sum(a.f_actual_eot) <> 0 or sum(a.f_planned_eot) <> 0
 order by b.l_setup_date;

--����
select s.c_projcode  as ��Ŀ����,
       s.c_fullname  as ��Ŀ����,
       s.d_begdate   as ��Ŀ��ʼ����,
       s.d_enddate   as ��Ŀ��������,
       t.c_fundcode  as ��Ʒ����,
       t.c_fundname  as ��Ʒ����,
       t.d_issuedate as ��Ʒ��������,
       t.d_setupdate as ��Ʒ��������,
       t.d_enddate   as ��Ʒ��ֹ����,
       t.d_liqudate  as ��Ʒ��������
  from ta_fundinfo t, pm_projectinfo s
 where t.c_projcode = s.c_projcode
   and t.d_setupdate is null;

--Ͷ�ʺ�ͬ���
select b.c_prod_code as ��Ʒ����,
       b.c_prod_name as ��Ʒ����,
       b.l_setup_date,
       sum(a.f_balance_agg) as Ͷ�����
  from tt_ic_invest_cont_m a, dim_pb_product b, dim_ic_contract c
 where a.l_prod_id = b.l_prod_id
   and a.l_cont_id = c.l_cont_id
   and a.l_month_id = 201608
   and substr(c.l_effective_date, 1, 6) <= 201608
   and substr(c.l_expiration_date, 1, 6) > 201608
 group by b.c_prod_code, b.c_prod_name, b.l_setup_date
 order by sum(a.f_balance_agg);
 
--������Ŀ����
select t.l_proj_id,
       t.c_proj_code,
       t.c_proj_name,
       t.l_setup_date,
       t.l_preexp_date,
       t.l_expiry_date,
       t.c_proj_status_n,
       t.c_proj_phase_n,
       s.c_book_code,
       r.f_balance_eot
  from dim_pb_project_basic t, dim_to_book s, (select * from tt_sr_scale_proj_m where l_month_id = 201609) r
 where nvl(t.l_expiry_date, 20991231) > 20160930
   and t.l_proj_id = s.l_proj_id(+)
   and t.l_proj_id = r.l_proj_id(+)
   and t.c_proj_phase >= '35'
   and t.l_effective_flag = 1;
   
   select * from tt_sr_scale_proj_m t where t.l_month_id = 201609;
   
   select * from dim_to_book t where t.c_book_code = '200222';
   
   select * from dim_pb_project_basic t where t.l_proj_id = 597;
   
--������ģ�ϼ�
select sum(a.f_balance_eot) / 100000000
  from tt_sr_scale_proj_m a, dim_pb_project_biz b, dim_pb_project_basic c
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = c.l_proj_id
   and a.l_month_id >= substr(c.l_effective_date, 1, 6)
   and a.l_month_id < substr(c.l_expiration_date, 1, 6)
   and a.l_month_id = 201606
   and nvl(c.l_expiry_date, '20991231') > 20160630;

--��Ʒ����
select d.c_proj_code,
       d.c_proj_name,
       c.c_prod_code,
       c.c_prod_name,
       b.c_ietype_name,
       sum(a.f_actual_agg) as �ۼ�ʵ������,
       sum(a.f_planned_agg) as �ۼƼƻ�����,
       sum(a.f_actual_agg - a.f_planned_agg) as �ۼ�δ��������
  from tt_ic_ie_party_d     a,
       dim_pb_ie_type       b,
       dim_pb_product       c,
       dim_pb_project_basic d
 where a.l_day_id = 20161110
   and a.l_prod_id = c.l_prod_id
   and a.l_proj_id = d.l_proj_id
   and d.l_effective_flag = 1
   and a.l_ietype_id = b.l_ietype_id
   and b.c_ietype_code_l1 = 'XTSR'
 group by d.c_proj_code,
          d.c_proj_name,
          c.c_prod_code,
          c.c_prod_name,
          b.c_ietype_name;

--��Ŀ����
select d.c_proj_code,
       d.c_proj_name,
       d.l_setup_date,
       d.c_Proj_Phase_n,
       b.c_ietype_name,
       sum(a.f_actual_agg) as �ۼ�ʵ������,
       sum(a.f_planned_agg) as �ۼƼƻ�����,
       sum(a.f_planned_agg - a.f_actual_agg) as �ۼ�δ��������
  from tt_ic_ie_party_m a, dim_pb_ie_type b, dim_pb_project_basic d
 where a.l_month_id = 201609
   and a.l_proj_id = d.l_proj_id
   and d.l_effective_flag = 1
   and a.l_ietype_id = b.l_ietype_id
   and b.c_ietype_code_l1 = 'XTSR'
 group by d.c_proj_code,
          d.c_proj_name,
          d.l_setup_date,
          d.c_Proj_Phase_n,
          b.c_ietype_name
 order by d.c_proj_phase_n, d.l_setup_date;
 
--��Ŀ����
select d.c_proj_code as ��Ŀ����,
       d.c_proj_name as ��Ŀ����,
       d.l_setup_date as ��������,
       d.c_Proj_Phase_n as ��Ŀ�׶�,
       e.c_dept_name as ��������,
       b.c_ietype_name as ��������,
       sum(a.f_actual_agg) as �ۼ�ʵ������,
       sum(a.f_planned_agg) as �ۼƼƻ�����,
       sum(a.f_planned_agg - a.f_actual_agg) as �ۼ�δ��������
  from tt_ic_ie_party_m a, dim_pb_ie_type b, dim_pb_project_basic d,dim_pb_department e
 where a.l_month_id = 201610
   and a.l_proj_id = d.l_proj_id
   and d.l_dept_id = e.l_dept_id
   and a.l_month_id >= substr(d.l_effective_date, 1, 6)
   and a.l_month_id < substr(d.l_expiration_date, 1, 6)
   and a.l_ietype_id = b.l_ietype_id
   and b.c_ietype_code_l3 = 'XTGDBC'
 group by d.c_proj_code,
          d.c_proj_name,
          d.l_setup_date,
          d.c_Proj_Phase_n,
          e.c_dept_name,
          b.c_ietype_name having sum(a.f_planned_agg - a.f_actual_agg) < 0
 order by  e.c_dept_name,d.c_proj_phase_n,d.l_setup_date;
 
 select * from Dim_Pb_Project_Basic t where t.c_proj_code = 'AVICTC2013X0451'
 
 
--BI���
with temp_scale as
 (select b.c_proj_code,
         b.c_proj_name,
         round(sum(a.f_balance_agg) / 10000, 2) as �������,
         round(sum(a.f_decrease_agg) / 10000, 2) as �ۼƻ���
    from tt_tc_scale_cont_m a, dim_pb_project_basic b
   where a.l_proj_id = b.l_proj_id
     and a.l_month_id = 201611
     and a.l_proj_id = b.l_proj_id
     and substr(b.l_effective_date, 1, 6) <= 201611
     and substr(b.l_expiration_date, 1, 6) > 201611
     and nvl(b.l_expiry_date, 20991231) > 20161130
   group by b.c_proj_code,b.c_proj_name),
temp_ie as
 (select d.c_proj_code,
         round(sum(c.f_planned_agg) / 10000, 2) as ��ͬ����,
         round(sum(decode(e.c_ietype_code_l2, 'XTBC', c.f_planned_agg, 0)) /
               10000,
               2) as ��ͬ����,
         round(sum(decode(e.c_ietype_code_l2, 'XTCGF', c.f_planned_agg, 0)) /
               10000,
               2) as ��ͬ�ƹ˷�
  
    from tt_ic_ie_party_m c, dim_pb_project_basic d, dim_pb_ie_type e
   where c.l_proj_id = d.l_proj_id
     and c.l_month_id = 201611
     and c.l_ietype_id = e.l_ietype_id
     and e.c_ietype_code_l1 = 'XTSR'
     and c.l_proj_id = d.l_proj_id
     and substr(d.l_effective_date, 1, 6) <= 201611
     and substr(d.l_expiration_date, 1, 6) > 201611
     and nvl(d.l_expiry_date, 20991231) > 20161130
   group by d.c_proj_code)
select *
  from temp_scale
  full outer join temp_ie
    on temp_scale.c_proj_code = temp_ie.c_proj_code --where temp_scale.c_proj_code =  'AVICTC2015X1029'
 order by temp_scale.c_Proj_code;


--�ʹܺ�ͬͶ�ʹ�ģ
select b.c_invest_indus_n, round(sum(a.f_balance_agg) / 100000000, 2)
  from tt_ic_invest_cont_m  a,
       dim_ic_contract      b,
       dim_pb_project_basic c,
       dim_pb_department    d
 where a.l_cont_id = b.l_cont_id
   and b.l_proj_id = c.l_proj_id
   and c.l_dept_id = d.l_dept_id
   and d.c_dept_code <> '841'
   and substr(b.l_effective_date, 1, 6) <= 201609
   and substr(b.l_expiration_date, 1, 6) > 201609
   and a.l_month_id = 201609
 group by b.c_invest_indus_n;
 
 select * from dim_pb_department;
 
 select * from dim_ic_contract a where exists(select 1 from dim_pb_project_biz b where a.l_proj_id = b.l_proj_id and a.c_invest_indus<>b.c_invest_indus);
 
 select t.*
   from tt_ic_ie_prod_m t
  where t.l_month_id = 201609
    and t.f_actual_agg > t.f_planned_agg;

select * from dim_pb_budget_item a;

--����
select *
  from (select a.l_month_id,
               c.month_of_year / 3 as ����,
               c.year_id as ���,
               b.c_item_code,
               b.c_item_name,
               lag(a.f_actual, 1, 0) over(partition by b.c_item_code, b.c_item_name order by a.l_month_id),
               a.f_actual
          from tt_pb_budget_m a, dim_pb_budget_item b, dim_month c
         where a.l_item_id = b.l_item_id
           and a.l_month_id = c.month_id
           and b.c_item_code in ('GS000002', 'GS000003', 'GS000004')) t
 where ���� = 4
   and ��� = 2016;
   
--ͬ��
select *
  from (select a.l_month_id,
               c.month_of_year / 3 as ����,
               c.year_id as ���,
               b.c_item_code,
               b.c_item_name,
               lag(a.f_actual, 1, 0) over(partition by b.c_item_code, b.c_item_name order by c.month_of_year, c.year_id),
               a.f_actual
          from tt_pb_budget_m a, dim_pb_budget_item b, dim_month c
         where a.l_item_id = b.l_item_id
           and a.l_month_id = c.month_id
           and b.c_item_code in ('GS000002', 'GS000003', 'GS000004')) t
 where ���� = 4
   and ��� = 2016;
   
--�мƻ���ʵ������
select c.c_proj_code as ��Ŀ����,
       c.c_proj_name as ��Ŀ����,
       c.l_setup_date as ��Ŀ��������,
       d.c_dept_name as ��������,
       b.c_prod_code as ��Ʒ����,
       sum(a.f_actual_agg) as ʵ������,
       sum(a.f_planned_agg) as �ƻ�����
  from tt_ic_ie_prod_m      a,
       dim_pb_product       b,
       dim_pb_project_basic c,
       dim_pb_department    d
 where a.l_prod_id = b.l_prod_id
   and a.l_proj_id = c.l_proj_id
   and c.l_dept_id = d.l_dept_id
   and a.l_ietype_id = 3
   and a.l_month_id = 201609
      --and c.c_proj_code = 'AVICTC2016X0247'
      --group by c.c_proj_code,c.c_proj_name,c.l_setup_date
   and a.f_planned_agg - a.f_actual_agg < 0
 group by c.c_proj_code,
          c.c_proj_name,
          c.l_setup_date,
          d.c_dept_name,
          b.c_prod_code
 order by c.l_setup_date desc, c.c_proj_code;

select substr(b.l_expiry_date, 1, 6),
       round(sum(a.f_pay_agg * 365) / sum(a.f_days_agg * a.f_scale_agg), 6)
  from tt_to_operating_book_m a,
       dim_pb_project_basic   b,
       dim_to_book            c,
       tt_pb_object_status_m  d,
       dim_pb_object_status   e
 where a.l_proj_id = b.l_proj_id
   and a.l_book_id = c.l_book_id
   and b.l_proj_id = d.l_object_id
   and d.l_objstatus_id = e.l_objstatus_id
   and d.c_object_type = 'XM'
   and a.l_month_id = d.l_month_id
   and a.l_month_id = 201610
   and b.l_effective_flag = 1
   and e.l_expiry_ty_flag = 1
 group by substr(b.l_expiry_date, 1, 6)
 order by substr(b.l_expiry_date, 1, 6);

/**************************************************************************************************************************************/
--������ֹ��Ŀ��ϸ
select c.c_book_code   as ���ױ���,
       b.c_proj_code   as ��Ŀ����,
       b.c_proj_name   as ��Ŀ����,
       b.l_setup_date  as ��Ŀ��������,
       b.l_expiry_date as ��Ŀ��ֹ����,
       a.f_days_agg    as ��Ŀ��������,
       a.f_scale_agg   as ʵ������,
       a.f_scale_ad    as �վ���ģ,
       a.f_cost_agg    as �ۼ����з���,
       a.f_income_agg  as �ۼ�����������,
       a.f_pay_agg     as �ۼ������˱���
  from tt_to_operating_book_m a,
       dim_pb_project_basic   b,
       dim_to_book            c,
       tt_pb_object_status_m  d,
       dim_pb_object_status   e
 where a.l_proj_id = b.l_proj_id
   and a.l_book_id = c.l_book_id
   and b.l_proj_id = d.l_object_id
   and d.c_object_type = 'XM'
   and d.l_objstatus_id = e.l_objstatus_id
   and e.l_expiry_ty_flag = 1
   and a.l_month_id = d.l_month_id
   and b.l_effective_flag = 1
   and a.l_month_id = 201610
-- and c.c_book_code = '100611'
--and nvl(b.l_expiry_date, 20991231) between 20160101 and 20161031
 order by c.c_book_code;
 
--�ʹ�����Ͷ������
select b.c_proj_code     as ��Ŀ����,
       b.c_name_full     as ��Ŀ����,
       a.c_book_code     as ���ױ���,
       a.c_book_name     as ��������,
       a.c_invest_type_n as ����Ͷ������,
       a.c_book_type_n   as ��������
  from dim_to_book a, dim_pb_project_basic b, dim_pb_department c
 where a.l_proj_id = b.l_proj_id
   and a.l_effective_flag = 1
   and b.l_dept_id = c.l_dept_id
   and c.c_dept_code = '841'
 order by b.c_proj_code;
 
--ǰʮ�ʽ���Դռ��
with temp_scale as
 (select t1.l_proj_id, sum(t1.f_increase_agg) as f_increase_agg, sum(t1.f_balance_agg) as f_balance_agg
    from tt_tc_scale_cont_m t1, dim_tc_contract t2
   where t1.l_cont_id = t2.l_cont_id
     and t1.l_month_id = 201609
     and t1.l_month_id >= substr(t2.l_effective_date, 1, 6)
     and t1.l_month_id < substr(t2.l_expiration_date, 1, 6)
   group by t1.l_proj_id)
select c.c_inst_code,
       c.c_inst_name,
       a.c_proj_code,
       a.c_proj_name,
       b.c_proj_type_n,
       d.f_increase_agg,
       d.f_balance_agg
  from dim_pb_project_basic a,
       dim_pb_project_biz   b,
       dim_pb_institution   c,
       temp_scale           d
 where a.l_proj_id = b.l_proj_id
   and b.l_bankrec_ho = c.l_inst_id
   and a.l_proj_id = d.l_proj_id(+)
   and a.l_effective_flag = 1;

select *
  from dim_pb_project_basic a, dim_pb_project_biz b
 where a.l_proj_id = b.l_proj_id
   and b.l_pool_flag = 1
   and nvl(a.l_expiry_date, 20991231) <= 20161130;

--Ͷ�ʺ�ͬ��ϸ��ҵͶ��
select a.c_cont_code,b.c_indus_name
  from dim_ic_contract a, dim_pb_industry b
 where a.l_invindus_id = b.l_indus_id
   and a.l_effective_flag = 1;

--�Ʊ����ݲ�ѯ
select a.c_item_name, b.f_money_tot, b.f_money_eot,b.f_money_lot
  from dim_fi_statement_item a, tt_fi_statement_m b
 where a.l_item_id = b.l_item_id
   and b.l_state_id = 6
   and b.l_month_id = 201609
 order by a.l_column_axis, a.l_row_axis;




-----------------------------------------------------------------������Ŀ----------------------------------------------------------------
--������ģ�ϼ�
select sum(a.f_balance_eot)/100000000 
from tt_sr_scale_proj_m a ,dim_pb_project_biz b ,dim_pb_project_basic c
where a.l_proj_id = b.l_proj_id and b.l_proj_id = c.l_proj_id
and a.l_month_id >= substr(c.l_effective_date,1,6)
and a.l_month_id < substr(c.l_expiration_date, 1,6)
and a.l_month_id = 201606 
and nvl(c.l_expiry_date,'20991231') > 20160630;

--������ģ�˶�	
select s.c_proj_code,round(sum(t.f_balance_eot)/10000,2) from tt_sr_scale_proj_d t,dim_pb_project_basic s 
where t.l_proj_id = s.l_proj_id and  t.l_day_id = 20161009 group by s.c_proj_code;

--������Ŀ����������Ŀ���ͣ����ܷ��࣬��������
select b.c_proj_type,
       b.c_proj_type_n,
       b.c_func_type,
       b.c_func_type_n,
       b.c_affair_props,
       b.c_affair_props_n,
       count(*)
  from tt_sr_scale_proj_d   a,
       dim_pb_project_biz   b,
       dim_sr_project_junk  c,
       dim_pb_project_basic d
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = d.l_proj_id
   and a.L_PROJ_JUNK_ID = c.L_PROJ_JUNK_ID
   and a.l_day_id = 20160831
   and c.l_exist_flag = 1
 group by b.c_proj_type,
          b.c_proj_type_n,
          b.c_func_type,
          b.c_func_type_n,
          b.c_affair_props,
          b.c_affair_props_n
 order by b.c_proj_type, b.c_func_type, b.c_affair_props;

--������Ŀ��ģ������Ŀ���ͣ����ܷ�����������
select b.c_proj_type,
       b.c_proj_type_n,
       b.c_func_type,
       b.c_func_type_n,
       b.c_affair_props,
       b.c_affair_props_n,
       sum(a.f_balance_eot) / 100000000
  from tt_sr_scale_proj_m a, dim_pb_project_biz b, dim_pb_project_basic c
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = c.l_proj_id
   and a.l_month_id = 201608
   and nvl(c.l_expiry_date, '20991231') > 20160831
   and a.l_month_id >= substr(c.l_effective_date, 1, 6)
   and a.l_month_id < substr(c.l_expiration_date, 1, 6)
 group by b.c_proj_type,
          b.c_proj_type_n,
          b.c_func_type,
          b.c_func_type_n,
          b.c_affair_props,
          b.c_affair_props_n
 order by b.c_proj_type, b.c_func_type, b.c_affair_props;

--��Ŀ����������ϸ
select b.l_proj_id,b.l_effective_flag,b.l_effective_date,b.c_proj_code,b.c_proj_name,b.l_setup_date,b.l_expiry_date,a.c_proj_type_n,a.c_func_type_n,a.c_affair_props,a.c_affair_props_n 
from dim_pb_project_biz a,dim_pb_project_basic b 
where a.l_Proj_id = b.l_proj_id 
and b.l_effective_flag = 1
order by b.c_proj_code,a.l_proj_id;

-----------------------------------------------------------------������Ŀ----------------------------------------------------------------
--������Ŀ����������Ŀ���ͣ����ܷ���
select b.c_proj_type,
       b.c_proj_type_n,
       b.c_func_type,
       b.c_func_type_n,
       b.c_affair_props,
       b.c_affair_props_n,
       count(*)
  from tt_sr_scale_proj_d a, dim_pb_project_biz b, dim_sr_project_junk c
 where a.l_proj_id = b.l_proj_id
   and a.L_PROJ_JUNK_ID = c.L_PROJ_JUNK_ID
   and a.l_day_id = 20160831
   and c.l_setup_ty_flag = 1
 group by b.c_proj_type,
          b.c_proj_type_n,
          b.c_func_type,
          b.c_func_type_n,
          b.c_affair_props,
          b.c_affair_props_n
 order by b.c_proj_type, b.c_func_type, b.c_affair_props;

--������Ŀ�����������ޣ���Ҫȷ�����޶�ά��׼ȷ
select case when nvl(c.l_time_limit,99) <= 12 then 'һ�������� else 'һ�������� end ����,count(*) 
from tt_sr_scale_proj_d a ,dim_sr_project_junk b,dim_pb_project_basic c
where a.l_proj_id = c.l_proj_id  
and a.L_PROJ_JUNK_ID = b.L_PROJ_JUNK_ID 
and a.l_proj_id = c.l_proj_id
and a.l_day_id = 20160630
and b.l_setup_ty_flag = 1 
group by case when nvl(c.l_time_limit,99) <= 12 then 'һ�������� else 'һ�������� end;

--������Ŀ��������������ϸ	
select c.c_proj_code,c.c_proj_name,case when nvl(c.l_time_limit,99) <= 12 then 'һ�������� else 'һ�������� end ����,count(*),sum(a.f_increase_eot) 
from tt_sr_scale_proj_d a ,dim_sr_project_junk b,dim_pb_project_basic c
where a.l_proj_id = c.l_proj_id  
and a.L_PROJ_JUNK_ID = b.L_PROJ_JUNK_ID 
and a.l_proj_id = c.l_proj_id
and a.l_day_id = 20160630
and b.l_setup_ty_flag = 1 
group by c.c_proj_code,c.c_proj_name,case when nvl(c.l_time_limit,99) <= 12 then 'һ�������� else 'һ�������� end;

--������Ŀ��ģ
select sum(a.f_increase_eot) from tt_sr_scale_stage_d a,dim_sr_stage b 
where a.l_stage_id = b.l_stage_id 
and B.L_SETUP_DATE > 20151231 
and a.l_day_id = 20160630;

--�³�����ģ���ǽ������깺
select c.c_proj_type,
       c.c_proj_type_n,
       c.c_func_type,
       c.c_func_type_n,
       c.c_affair_props,
       c.c_affair_props_n,
       sum(case
             when b.c_scatype_code = '50' then
              a.f_incurred_eot
             when b.c_scatype_code = '02' and l_valuation_flag <> 1 then
              a.f_incurred_eot
             else
              0
           end) / 100000000 as f_scale
  from tt_sr_scale_type_m   a,
       dim_sr_scale_type    b,
       dim_pb_project_biz   c,
       dim_pb_project_basic d
 where a.l_proj_id = c.l_proj_id
   and c.l_proj_id = d.l_proj_id
   and a.l_scatype_id = b.l_scatype_id
   and a.l_month_id = 201608
 group by c.c_proj_type,
          c.c_proj_type_n,
          c.c_func_type,
          c.c_func_type_n,
          c.c_affair_props,
          c.c_affair_props_n
 order by c.c_proj_type, c.c_func_type, c.c_affair_props;

-----------------------------------------------------------------������Ŀ----------------------------------------------------------------
--������Ŀ����������Ŀ���ͣ����ܷ���
select b.c_proj_type_n,b.c_func_type_n,b.c_affair_props_n,count(*) from tt_sr_scale_proj_d a ,dim_pb_project_biz b ,dim_sr_project_junk c
where a.l_proj_id = b.l_proj_id  
and a.L_PROJ_JUNK_ID = c.L_PROJ_JUNK_ID
and a.l_day_id = 20160630
and c.l_clear_ty_flag = 1
group by b.c_proj_type_n,b.c_func_type_n,b.c_affair_props_n 
order by b.c_proj_type_n,b.c_func_type_n,b.c_affair_props_n;

--�ǽ������
select c.c_proj_type_n,c.c_func_type_n,c.c_affair_props_n,
sum(case when b.c_scatype_code = '03' and l_valuation_flag <> 1 then a.f_incurred_agg else 0 end)/100000000 as f_scale
from tt_sr_scale_type_m a ,dim_sr_scale_type b,dim_pb_project_biz c ,dim_pb_project_basic d
where a.l_proj_id = c.l_proj_id 
and c.l_proj_id = d.l_proj_id
and a.l_scatype_id = b.l_scatype_id 
and a.l_month_id = 201606
and nvl(d.l_expiry_date,'20010101') > 20151231
and a.l_month_id >= substr(d.l_effective_date,1,6)
and a.l_month_id < substr(d.l_expiration_date, 1,6)
group by c.c_proj_type_n,c.c_func_type_n,c.c_affair_props_n 
order by c.c_proj_type_n,c.c_func_type_n,c.c_affair_props_n ;

--�Ҹ���ģ���ǹ�ֵ�����
select 
sum(case when b.c_scatype_code = '03' and l_valuation_flag <> 1 then a.f_incurred_eot else 0 end)/100000000 as f_scale
from tt_sr_scale_type_m a ,dim_sr_scale_type b,dim_pb_project_biz c ,dim_pb_project_basic d
where a.l_proj_id = c.l_proj_id 
and c.l_proj_id = d.l_proj_id
and a.l_scatype_id = b.l_scatype_id 
and a.l_month_id = 201606;

--�Ҹ���ģ����ֵ����ֹ��Ŀ�������
select d.c_proj_code,
sum( a.f_incurred_eot )/100000000 as f_scale
from tt_sr_scale_type_m a ,dim_sr_scale_type b,dim_pb_project_biz c ,dim_pb_project_basic d
where a.l_proj_id = c.l_proj_id 
and c.l_proj_id = d.l_proj_id
and a.l_scatype_id = b.l_scatype_id 
and c.l_valuation_flag = 1
and b.c_scatype_code = '03'
and nvl(d.l_expiry_date,'20991231') between 20160101 and 20160630
and a.l_month_id = 201606
group by d.c_proj_code;

--��ֹ��Ŀ���
select b.c_proj_code,b.c_proj_name,b.l_expiry_date,
a.f_exist_days,a.f_scale_agg,a.f_trust_cost,a.f_benefic_income,a.f_trust_pay,a.f_cost_rate,a.f_benefic_rate,a.f_pay_rate
from tt_po_rate_proj_d a ,dim_pb_project_basic b ,dim_pb_project_biz c
where a.l_proj_id = b.l_proj_id
and b.l_proj_id = c.l_proj_id
and nvl(b.l_expiry_date,20991231) between 20160101 and 20160630
and a.l_day_id = 20160630
order by b.c_proj_code;

--�����ģ
select a.l_proj_id,
       a.f_incurred_agg,
       b.l_proj_id,
       b.c_proj_code,
       b.c_proj_name,
       b.l_expiry_date
  from (select t.l_proj_id, sum(t.f_incurred_agg) as f_incurred_agg
          from tt_sr_scale_type_m t
         where t.l_scatype_id = 1301
           and t.l_month_id = 201608
         group by t.l_proj_id) a,
       (select *
          from dim_pb_project_basic t
         where t.l_dept_id = 2
           and t.l_effective_flag = 1
           and nvl(t.l_expiry_date, '20991231') between 20160101 and
               20160831) b
 where a.l_proj_id = b.l_proj_id;
 
--��ֹ��Ŀ���
select b.c_proj_code,
a.f_scale_agg,
a.f_exist_days,
a.f_trust_cost,
a.f_benefic_income,
a.f_trust_Pay,
a.f_cost_rate,
a.f_benefic_rate,
a.f_benefic_rate 
from tt_po_rate_proj_d a,dim_pb_project_basic b 
where b.l_proj_id = a.l_proj_id 
and  a.l_day_id = 20160630
and nvl(b.l_expiry_date,20991231) between 20160101 and 20160630
order by b.c_proj_code;

 --��ֹ��Ŀ��ϸ
with temp_qs as
 (select b.l_proj_id,
         b.c_proj_code,
         b.c_proj_name,
         b.l_expiry_date,
         ROUND(a.f_incurred_agg / 10000, 4) as f_qs
    from (select t.l_proj_id, sum(t.f_incurred_agg) as f_incurred_agg
            from tt_sr_scale_type_m t
           where t.l_scatype_id = 1301
             and t.l_month_id = 201608
           group by t.l_proj_id) a,
         (select *
            from dim_pb_project_basic t
           where t.l_effective_flag = 1
             and nvl(t.l_expiry_date, '20991231') between 20160801 and
                 20160831) b
   where a.l_proj_id = b.l_proj_id)
select d.c_proj_type_n,
       d.c_func_type_n,
       d.c_affair_props_n,
       b.c_proj_code,
       b.c_proj_name,
       round(A.F_SCALE_AGG / 10000, 4),
       c.f_qs,
       A.F_EXIST_DAYS,
       A.F_TRUST_PAY,
       A.F_BENEFIC_INCOME,
       A.F_TRUST_COST,
       A.F_PAY_RATE,
       A.F_BENEFIC_RATE,
       A.F_COST_RATE
  from tt_po_rate_proj_d    a,
       dim_pb_project_basic b,
       temp_qs              c,
       dim_pb_project_biz   d
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = d.l_proj_id
   and a.l_proj_id = c.l_proj_id
   and a.l_day_id = 20160831
   and nvl(b.l_expiry_date, '20991231') between 20160801 and 20160831;
   
--��ֹ��Ŀ��ϸ
with temp_qs as
 (select b.l_proj_id,
         b.c_proj_code,
         b.c_proj_name,
         b.l_expiry_date,
         ROUND(a.f_incurred_agg / 10000, 4) as f_qs
    from (select t.l_proj_id, sum(t.f_incurred_agg) as f_incurred_agg
            from tt_sr_scale_type_m t
           where t.l_scatype_id = 1301
             and t.l_month_id = 201608
           group by t.l_proj_id) a,
         (select *
            from dim_pb_project_basic t
           where t.l_effective_flag = 1
             and nvl(t.l_expiry_date, '20991231') between 20160801 and
                 20160831) b
   where a.l_proj_id = b.l_proj_id)
select d.c_proj_type,
       d.c_proj_type_n,
       d.c_func_type,
       d.c_func_type_n,
       d.c_affair_props,
       d.c_affair_props_n,
       count(*),
       round(sum(A.F_SCALE_AGG) / 10000, 4),
       sum(c.f_qs),
       round(sum(A.F_TRUST_PAY) / 10000, 4),
       round(sum(A.F_BENEFIC_INCOME) / 10000, 4),
       round(sum(a.f_trust_cost) / 10000, 4)
  from tt_po_rate_proj_d    a,
       dim_pb_project_basic b,
       temp_qs              c,
       dim_pb_project_biz   d
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = d.l_proj_id
   and a.l_proj_id = c.l_proj_id
   and a.l_day_id = 20160831
   and nvl(b.l_expiry_date, '20991231') between 20160801 and 20160831
 group by d.c_proj_type,
          d.c_proj_type_n,
          d.c_func_type,
          d.c_func_type_n,
          d.c_affair_props,
          d.c_affair_props_n
 order by d.c_proj_type, d.c_func_type, d.c_affair_props;

-----------------------------------------------------------------�Ҹ���ģ----------------------------------------------------------------
select t1.c_dept_name,
       t1.c_proj_code,
       t1.c_proj_name,
       t1.L_valuation_flag,
       t1.f_scale - nvl(t2.f_scale, 0)
  from (select e.c_dept_name,
               d.c_proj_code,
               d.c_proj_name,
               c.L_valuation_flag,
               sum(a.f_incurred_eot) as f_scale
          from tt_sr_scale_type_m   a,
               dim_sr_scale_type    b,
               dim_pb_project_biz   c,
               dim_pb_project_basic d,
               dim_pb_department    e
         where a.l_proj_id = c.l_proj_id
           and c.l_proj_id = d.l_proj_id
           and a.l_scatype_id = b.l_scatype_id
           and d.l_dept_id = e.l_dept_id
           and c.l_valuation_flag = 0
           and b.c_scatype_code = '03'
           and nvl(d.l_expiry_date, '20991231') >= 20160101
           and a.l_month_id = 201608
         group by e.c_dept_name,
                  d.c_proj_code,
                  d.c_proj_name,
                  c.L_valuation_flag) t1,
       (select e.c_dept_name,
               d.c_proj_code,
               d.c_proj_name,
               c.l_valuation_flag,
               sum(a.f_incurred_agg) as f_scale
          from tt_sr_scale_type_m   a,
               dim_sr_scale_type    b,
               dim_pb_project_biz   c,
               dim_pb_project_basic d,
               dim_pb_department    e
         where a.l_proj_id = c.l_proj_id
           and c.l_proj_id = d.l_proj_id
           and a.l_scatype_id = b.l_scatype_id
           and d.l_dept_id = e.l_dept_id
           and c.l_valuation_flag = 0
           and b.c_scatype_code = 'QS'
           and nvl(d.l_expiry_date, '20991231') between 20160101 and
               20160831
           and a.l_month_id = 201608
         group by e.c_dept_name,
                  d.c_proj_code,
                  d.c_proj_name,
                  c.l_valuation_flag) t2
 where t1.c_proj_code = t2.c_proj_code(+)
   and t1.c_dept_name = '�ʲ�����һ��'
order by t1.c_dept_name,t1.c_proj_code;

-----------------------------------------------------------------�������ģ�䶯----------------------------------------------------------------
select c.c_proj_code,c.c_proj_name,
round(sum(decode(b.c_scatype_code,'02',a.f_incurred_tot,0))/10000,2) as �깺, 
round(sum(decode(b.c_scatype_code,'03',a.f_incurred_tot,0))/10000,2) as ���
from tt_sr_scale_type_d a,dim_sr_scale_type b,dim_pb_project_basic c,dim_pb_project_biz d
where a.l_scatype_id = b.l_scatype_id 
and a.l_proj_id = c.l_proj_id 
and c.l_proj_id = d.l_proj_id 
and c.l_effective_flag = 1 
and d.l_valuation_flag = 1
and B.C_SCATYPE_CLASS = 'XTHTGM' 
and b.c_scatype_code in ('02','03') and a.f_incurred_tot <> 0
and  a.l_day_id >= 20161001 and  a.l_day_id <= 20161010
group by c.c_proj_code,c.c_proj_name;

-----------------------------------------------------------------����ṹ----------------------------------------------------------------
--����ҵ�����룬������״̬
select A.L_REVSTATUS_ID,sum(a.f_actual_eot)/10000 from tt_sr_tstrev_proj_m a,dim_pb_project_basic b 
where a.l_proj_id = b.l_proj_id 
and a.l_month_id >= substr(b.l_effective_date,1,6)
and a.l_month_id < substr(b.l_expiration_date, 1,6)
and a.l_month_id = 201606 group by A.L_REVSTATUS_ID;

--����ҵ�����밴��Ŀ����
select c.c_proj_type_n,sum(a.f_planned_eot)/10000 from tt_sr_tstrev_proj_m a,dim_pb_project_basic b,dim_pb_project_biz c
where a.l_proj_id = b.l_proj_id 
and b.l_proj_id = C.L_PROJ_ID
and a.l_month_id >= substr(b.l_effective_date,1,6)
and a.l_month_id < substr(b.l_expiration_date, 1,6)
and a.l_month_id = 201606 
group by c.c_proj_type_n;

--����ҵ�����밴ҵ��Χ����Ŀ���͡����ܷ���
select c.c_busi_scope_n,
       c.c_proj_type_n,
       c.c_func_type_n,
       round(sum(a.f_actual_eot) / 10000, 2)
  from tt_sr_tstrev_proj_m a, dim_pb_project_basic b, dim_pb_project_biz c
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = C.L_PROJ_ID
   and a.l_month_id >= substr(b.l_effective_date, 1, 6)
   and a.l_month_id < substr(b.l_expiration_date, 1, 6)
   and a.l_month_id = 201608
 group by c.c_busi_scope_n,
          c.c_proj_type_n,
          c.c_func_type_n having round(sum(a.f_planned_eot) / 10000, 2) <> 0
 order by c.c_busi_scope_n, c.c_proj_type_n, c.c_func_type_n;

--����ҵ�����밴ҵ��Χ����Ŀ���͡����ܷ���
select c.c_busi_scope, 
        c.c_busi_scope_n,
        c.c_proj_type,
       c.c_proj_type_n,
       c.c_func_type,
       c.c_func_type_n,
       c.c_affair_props,
       c.c_affair_props_n,
       round(sum(a.f_actual_eot) / 10000, 2)
  from tt_sr_tstrev_proj_m a, dim_pb_project_basic b, dim_pb_project_biz c
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = C.L_PROJ_ID
   and a.l_month_id >= substr(b.l_effective_date, 1, 6)
   and a.l_month_id < substr(b.l_expiration_date, 1, 6)
   and a.l_month_id = 201608
 group by c.c_busi_scope, c.c_busi_scope_n,
          c.c_proj_type,c.c_proj_type_n,
           c.c_func_type,c.c_func_type_n,
          c.c_affair_props,c.c_affair_props_n 
          having round(sum(a.f_planned_eot) / 10000, 2) <> 0
 order by c.c_busi_scope, c.c_proj_type, c.c_func_type,c.c_affair_props;

--��������
select b.l_dept_id,
b.c_dept_name,
sum(decode(a.l_revstatus_id,2,a.f_actual_eot,0))/10000 as f_exist,
sum(decode(a.l_revstatus_id,1,a.f_actual_eot,0))/10000 as f_new
from tt_pe_dept_revenue_m a,dim_pb_department b 
where a.l_dept_id = b.l_dept_id 
and a.l_month_id = 201607
group by b.l_dept_id,b.c_dept_name
order by b.l_dept_id,b.c_dept_name;

-----------------------------------------------------------------ֱͶ����----------------------------------------------------------------
--������������/ֱͶ����
select s.c_proj_code,s.c_proj_name,s.l_setup_date,t.c_fdsrc_name,t.c_inst_name
  from (select a.l_proj_id,b.c_fdsrc_name,c.c_inst_name,count(*),sum(a.f_balance_eot) as f_scale
          from tt_tc_scale_inst_d a,
               dim_tc_fund_source b,
               dim_pb_institution c,
               dim_pb_project_basic d
         where a.l_fdsrc_id = b.l_fdsrc_id
           and a.l_fdsrc_inst_id = c.l_inst_id
           and a.l_proj_id = d.l_proj_id
           and substr(d.l_setup_date,1,4) = 2016
           and a.l_day_id = 20160630
           and b.c_fdsrc_code like '11%'
           and c.c_inst_name like '%��ͨ����'
           /*and a.f_balance_eot > 0*/
           group by a.l_proj_id,b.c_fdsrc_name,c.c_inst_name) t,dim_pb_project_basic s
   where t.l_proj_id = s.l_proj_id 
   order by t.c_inst_name,s.c_proj_code;

--������������/ֱͶ��ģ����Ŀ
select s.c_proj_code,s.c_proj_name,s.l_setup_date,t.c_fdsrc_name,t.c_inst_name,t.f_scale
  from (select a.l_proj_id,b.c_fdsrc_name,c.c_inst_name,count(*),sum(a.f_balance_eot) as f_scale
          from tt_tc_scale_inst_d a,
               dim_tc_fund_source b,
               dim_pb_institution c,
               dim_pb_project_basic d
         where a.l_fdsrc_id = b.l_fdsrc_id
           and a.l_fdsrc_inst_id = c.l_inst_id
           and a.l_proj_id = d.l_proj_id
           and a.l_day_id = 20160630
           and b.c_fdsrc_code like '11%'
           and c.c_inst_name like '%��ͨ����'
           /*and a.f_balance_eot > 0*/
           and exists(select 1 from dim_sr_stage e,dim_pb_project_basic f 
                      where e.l_proj_id = f.l_proj_id 
                      and d.c_proj_code = f.c_proj_code 
                      and substr(e.l_setup_date,1,4) = 2016)
           group by a.l_proj_id,b.c_fdsrc_name,c.c_inst_name) t,dim_pb_project_basic s
   where t.l_proj_id = s.l_proj_id 
   order by t.c_inst_name,s.c_proj_code;

--������������/ֱͶ��ģ���ڴ�
select s.c_proj_code,s.c_proj_name,s.l_setup_date,t.c_fdsrc_name,t.c_inst_name,t.f_scale
  from (select e.l_proj_id,b.c_fdsrc_name,c.c_inst_name,count(*),sum(a.f_balance_eot) as f_scale
          from tt_tc_fdsrc_stage_d a,
               dim_tc_fund_source b,
               dim_pb_institution c,
               dim_sr_stage d,
               dim_pb_project_basic e
         where a.l_fdsrc_id = b.l_fdsrc_id
           and a.l_fdsrc_inst_id = c.l_inst_id
           and a.l_stage_id = d.l_stage_id
           and d.l_proj_id = e.l_proj_id
           and a.l_day_id = 20160630
           and b.c_fdsrc_code like '12%'
           and c.c_inst_name like '%��ͨ����%'
           /*and a.f_balance_eot > 0*/
           and substr(d.l_setup_date,1,4) = 2016
           group by e.l_proj_id,b.c_fdsrc_name,c.c_inst_name) t,dim_pb_project_basic s
   where t.l_proj_id = s.l_proj_id 
   order by t.c_inst_name,s.c_proj_code;

--����������ģ
select s.c_proj_code,s.c_proj_name,s.l_expiry_date,t.c_fdsrc_name,t.c_inst_name,t.f_scale
  from (select a.l_proj_id,b.c_fdsrc_name,c.c_inst_name,count(*),sum(a.f_balance_eot) as f_scale
          from tt_tc_scale_inst_d a,
               dim_tc_fund_source b,
               dim_pb_institution c,
               dim_pb_project_basic d
         where a.l_fdsrc_id = b.l_fdsrc_id
           and a.l_fdsrc_inst_id = c.l_inst_id
           and a.l_proj_id = d.l_proj_id
           and nvl(d.l_expiry_date,20991231) > 20160630
           and a.l_day_id = 20160630
           and b.c_fdsrc_code like '11%'
           /*and c.c_inst_name not like '%��ͨ����/
           /*and a.f_balance_eot > 0*/
           group by a.l_proj_id,b.c_fdsrc_name,c.c_inst_name) t,dim_pb_project_basic s
   where t.l_proj_id = s.l_proj_id 
   order by t.c_inst_name,s.c_proj_code;
   
--����������ģ
select s.c_proj_code,s.c_proj_name,s.l_expiry_date,t.c_fdsrc_name,t.c_inst_name,t.f_scale
  from (select a.l_proj_id,b.c_fdsrc_name,c.c_inst_name,count(*),sum(a.f_balance_eot) as f_scale
          from tt_tc_fdsrc_proj_m a,
               dim_tc_fund_source b,
               dim_pb_institution c,
               dim_pb_project_basic d
         where a.l_fdsrc_id = b.l_fdsrc_id
           and a.l_fdsrc_inst_id = c.l_inst_id
           and a.l_proj_id = d.l_proj_id
           and nvl(d.l_expiry_date,20991231) > 20161031
           and a.l_month_id = 201610
           and b.c_fdsrc_code like '12%'
           /*and c.c_inst_name not like '%��ͨ����/
           /*and a.f_balance_eot > 0*/
           group by a.l_proj_id,b.c_fdsrc_name,c.c_inst_name) t,dim_pb_project_basic s
   where t.l_proj_id = s.l_proj_id 
   order by t.c_inst_name,s.c_proj_code;
   
--��ͬ�ʽ���Դ
select b.c_cont_code,
       s.c_proj_code,
       s.c_proj_name,
       e.c_cust_name,
       c.c_fdsrc_name,
       d.c_inst_name,
       sum(t.f_scale)
  from tt_tc_scale_flow_d   t,
       dim_tc_contract      b,
       dim_pb_project_basic s,
       dim_tc_fund_source   c,
       dim_pb_institution   d,
       dim_ca_customer      e
 where t.l_cont_id = b.l_cont_id
   and b.l_proj_id = s.l_proj_id
   and b.l_settler_id = e.l_cust_id(+)
   and nvl(b.l_fdsrc_Id, 0) = c.l_fdsrc_id(+)
   and nvl(b.l_fdsrc_inst_id, 0) = d.l_inst_id(+)
   and s.c_proj_name like '%�Ƚ�1304��%'
   and t.l_change_date <= 20160831
   and b.l_expiration_date > 20160831
 group by b.c_cont_code,
          s.c_proj_code,
          s.c_proj_name,
          e.c_cust_name,
          c.c_fdsrc_name,
          d.c_inst_name
 order by s.c_proj_code,
          s.c_proj_name,
          e.c_cust_name,
          c.c_fdsrc_name,
          d.c_inst_name;

-----------------------------------------------------------------������Ӫ----------------------------------------------------------------
--������Ŀ�ʽ����÷�ʽ��ϸ
select c.c_proj_type_n,d.c_proj_code,d.c_proj_name,b.c_scatype_name,
sum(f_incurred_agg) as f_scale
from tt_sr_scale_type_m a ,dim_sr_scale_type b,dim_pb_project_biz c ,dim_pb_project_basic d
where a.l_proj_id = c.l_proj_id
and c.l_proj_id = d.l_proj_id
and a.l_scatype_id = b.l_scatype_id 
and b.c_scatype_class = 'ZJYYFS' 
and nvl(d.l_expiry_date,20991231) > 20160630
and a.l_month_id = 201606
group by c.c_proj_type_n,d.c_proj_code,d.c_proj_name,b.c_scatype_name having sum(f_incurred_agg) > 0
order by c.c_proj_type_n,d.c_proj_code,d.c_proj_name,b.c_scatype_name;

--������Ŀ�ʽ����÷�ʽ��ϸ
select c.c_proj_type_n,d.c_proj_code,d.c_proj_name,
round(sum(decode(b.c_scatype_code,'DK',a.f_incurred_agg,0))/10000,2) as f_dk,
round(sum(decode(b.c_scatype_code,'JYXJRZC',a.f_incurred_agg,0))/10000,2) as f_JYXJRZC,
round(sum(decode(b.c_scatype_code,'KGCS',a.f_incurred_agg,0))/10000,2) as f_KGCS,
round(sum(decode(b.c_scatype_code,'CQGQTZ',a.f_incurred_agg,0))/10000,2) as f_CQGQTZ,
round(sum(decode(b.c_scatype_code,'ZL',a.f_incurred_agg,0))/10000,2) as f_ZL,
round(sum(decode(b.c_scatype_code,'MRFS',a.f_incurred_agg,0))/10000,2) as f_MRFS,
round(sum(decode(b.c_scatype_code,'CC',a.f_incurred_agg,0))/10000,2) as f_CC,
round(sum(decode(b.c_scatype_code,'CFTY',a.f_incurred_agg,0))/10000,2) as f_CFTY,
round(sum(decode(b.c_scatype_code,'QTZJYYFS',a.f_incurred_agg,0))/10000,2) as f_QTZJYYFS
from tt_sr_scale_type_m a ,dim_sr_scale_type b,dim_pb_project_biz c ,dim_pb_project_basic d
where a.l_proj_id = c.l_proj_id
and c.l_proj_id = d.l_proj_id
and a.l_scatype_id = b.l_scatype_id 
and b.c_scatype_class = 'ZJYYFS' 
and nvl(d.l_expiry_date,20991231) > 20160831
and a.l_month_id = 201608
group by c.c_proj_type_n,d.c_proj_code,d.c_proj_name
order by c.c_proj_type_n,d.c_proj_code,d.c_proj_name;

--������ĿͶ����ҵ��ϸ
select c.c_proj_type_n,d.c_proj_code,d.c_proj_name,b.c_scatype_name,
sum(f_incurred_agg) as f_scale
from tt_sr_scale_type_m a ,dim_sr_scale_type b,dim_pb_project_biz c ,dim_pb_project_basic d
where a.l_proj_id = c.l_proj_id 
and c.l_proj_id = d.l_proj_id
and a.l_scatype_id = b.l_scatype_id 
and b.c_scatype_class = 'TXHY' and nvl(d.l_expiry_date,20991231) > 20160630
and a.l_month_id = 201606
group by c.c_proj_type_n,d.c_proj_code,d.c_proj_name,b.c_scatype_name having sum(f_incurred_agg) > 0
order by c.c_proj_type_n,d.c_proj_code,d.c_proj_name,b.c_scatype_name;

	

--���ز�
select b.c_proj_code,b.c_proj_name,e.c_invest_indus_n,c.c_scatype_name,a.f_incurred_agg
from tt_sr_scale_type_m a,dim_pb_project_basic b ,dim_sr_scale_type c,dim_pb_project_biz e
where a.l_proj_id = b.l_proj_id 
and a.l_scatype_id = c.l_scatype_id 
and c.c_scatype_class = 'TXHY' 
and b.l_proj_id = e.l_proj_id
and nvl(b.l_expiry_date,20991231) >=20160630 
and a.l_month_id = 201606 and a.f_incurred_agg > 0
and exists (select 1 from tt_sr_scale_type_m t where a.l_proj_id = t.l_proj_id and a.l_month_id = t.l_month_id and t.l_scatype_id = 1011 and t.f_incurred_agg > 0)
order by b.c_proj_code,b.c_proj_name,e.c_invest_indus_n,a.f_incurred_agg desc;

-----------------------------------------------------------------ЭͬЧӦ----------------------------------------------------------------
--�м�ҵ������
select c.c_revtype_name,sum(a.f_midrev_int_eot) from tt_ic_midrev_proj_m a,dim_pb_project_basic b,dim_sr_revenue_type c
where a.l_proj_id = b.l_proj_id 
and a.l_revtype_id = c.l_revtype_id
and substr(B.L_EFFECTIVE_DATE,1,6) <= A.L_MONTH_ID
and substr(B.L_EXPIRATION_DATE,1,6) > A.L_MONTH_ID
and a.l_month_id = 201606
group by c.c_revtype_name;

--�޷���������
select c.c_proj_code, c.c_proj_name, sum(a.f_midrev_int_eot)
  from tt_ic_midrev_proj_m a, dim_pb_project_biz b, dim_pb_project_basic c
 where a.l_proj_id = b.l_proj_id(+)
   and b.l_proj_id = c.l_proj_id
   and b.l_bankrec_sub is null
   and a.l_month_id = 201608
   and substr(c.L_EFFECTIVE_DATE, 1, 6) <= A.L_MONTH_ID
   and substr(c.L_EXPIRATION_DATE, 1, 6) > A.L_MONTH_ID
 group by c.c_proj_code, c.c_proj_name
having sum(a.f_midrev_int_eot) <> 0;

--�����ֹ�Ԥ��ֵ
select a.c_item_code,a.c_item_name,B.F_ACTUAL
from dim_pb_budget_item a ,tt_pb_budget_y b
where A.L_ITEM_ID = B.L_ITEM_ID 
and A.C_ITEM_CODE in ('JYGS0011','JYGS0012','JYGS0013','JYGS0014')
and b.l_year_id = 2016;

--�м�ҵ�����밴����
select d.l_dept_id,d.c_dept_Name,
round(sum(decode(c.c_revtype_name,'�м䱣�ܷ�',a.f_midrev_int_eot,0))/10000,2) �м䱣�ܷ�,
round(sum(decode(c.c_revtype_name,'�м�ƹ˷�',a.f_midrev_int_eot,0))/10000,2) �м�ƹ˷�,
round(sum(decode(c.c_revtype_name,'�м䷢�з�',a.f_midrev_int_eot,0))/10000,2) �м䷢�з�,
round(sum(decode(c.c_revtype_name,'�м�����',a.f_midrev_int_eot,0))/10000,2) �м�����
from tt_ic_midrev_proj_m a,dim_pb_project_basic b,dim_sr_revenue_type c,dim_pb_department d
where a.l_proj_id = b.l_proj_id 
and a.l_revtype_id = c.l_revtype_id
and b.l_dept_id = d.l_dept_id
and substr(B.L_EFFECTIVE_DATE,1,6) <= A.L_MONTH_ID
and substr(B.L_EXPIRATION_DATE,1,6) > A.L_MONTH_ID
and a.l_month_id = 201608
group by d.l_dept_id,d.c_dept_Name
order by d.l_dept_id,d.c_dept_Name
;

--ĳ����ĳ������
select b.c_proj_code,
       b.c_proj_name,
       c.c_revtype_name,
       round(sum(a.f_midrev_int_eot) / 10000, 2)
  from tt_ic_midrev_proj_m  a,
       dim_pb_project_basic b,
       dim_sr_revenue_type  c,
       dim_pb_department    d
 where a.l_proj_id = b.l_proj_id
   and a.l_revtype_id = c.l_revtype_id
   and b.l_dept_id = d.l_dept_id
   and d.c_dept_name = '����ҵ��һ��'
and substr(B.L_EFFECTIVE_DATE,1,6) <= A.L_MONTH_ID
and substr(B.L_EXPIRATION_DATE,1,6) > A.L_MONTH_ID
and a.l_month_id = 201608
and c.c_revtype_name = '�м䱣�ܷ�'
 group by b.c_proj_code, b.c_proj_name, c.c_revtype_name
having sum(a.f_midrev_int_eot) <> 0;

--������Ŀ�м�ҵ��������ˮ
select b.c_proj_code,b.c_proj_name,c.c_revtype_name,a.* from tt_ic_revenue_flow_d a ,dim_pb_project_basic b,dim_sr_revenue_type c 
where a.l_proj_id = b.l_proj_id 
and a.l_revtype_id = c.l_revtype_id
and b.c_proj_code = 'EA42'
order by c.c_revtype_name, l_revdate_id;

--��������
with temp_fdsrc as (
select row_number()over(partition by c.c_proj_code 
                        order by a.l_fdsrc_id,case when b.c_fdsrc_code like '11%' and d.c_inst_name ='��ͨ����' then '1ֱͶ' when b.c_fdsrc_code like '12%' and d.c_inst_name ='��ͨ����' then '2���' else '3����' end desc) as l_rn,
c.c_proj_code ,
case when b.c_fdsrc_code like '11%' and d.c_inst_name ='��ͨ����' then '1ֱͶ' when b.c_fdsrc_code like '12%' and d.c_inst_name ='��ͨ����' then '2���' else '3����' end as c_fdsrc_name
from tt_tc_scale_inst_d a,dim_tc_fund_source b,dim_pb_project_basic c,dim_pb_institution d
where 
a.l_fdsrc_id = b.l_fdsrc_id 
and a.l_proj_id = c.l_proj_id and a.l_fdsrc_inst_id = d.l_inst_id(+)
and a.l_day_id = 20160831
),
temp_actual_year as (select b.c_proj_code,sum(a.f_actual_tot) as f_actual_year
from tt_sr_tstrev_proj_m a,dim_pb_project_basic b 
where a.l_proj_id = b.l_proj_id 
and a.l_month_id >= substr(b.l_effective_date,1,6)
and a.l_month_id < substr(b.l_expiration_date, 1,6)
and substr(a.l_month_id,1,4) = 2016 and a.l_month_Id <= 201608
group by b.c_proj_code,b.c_proj_name),
temp_planned_year as (select b.c_proj_code,sum(a.f_planned_eot) as f_planned_year
from tt_sr_tstrev_proj_m a,dim_pb_project_basic b 
where a.l_proj_id = b.l_proj_id 
and a.l_month_id >= substr(b.l_effective_date,1,6)
and a.l_month_id < substr(b.l_expiration_date, 1,6)
and a.l_month_id = 201608
group by b.c_proj_code)
select d.c_fdsrc_name,c.c_inst_name,a.c_proj_code ,a.c_proj_name,sum(e.f_actual_year)
from dim_pb_project_basic a ,dim_pb_project_biz b,dim_pb_institution c,temp_fdsrc d,temp_actual_year e,temp_planned_year f
where b.l_bankrec_sub = c.l_inst_id
and a.l_proj_id = b.l_proj_id
--and nvl(A.L_EXPIRY_DATE,20991231) >= 20160101
and a.l_effective_flag = 1
and a.c_proj_code = d.c_proj_code 
and d.l_rn = 1
and a.c_proj_code = e.c_proj_code
and a.c_proj_code = f.c_proj_code
group by d.c_fdsrc_name, c.c_inst_name,a.c_proj_code ,a.c_proj_name
order  by d.c_fdsrc_name,c.c_inst_name, a.c_proj_code ,a.c_proj_name;

--��Ŀ�ʽ���Դ��ϸ
select row_number()over(partition by c.c_proj_code order by case when b.c_fdsrc_code like '11%' then '1ֱͶ when b.c_fdsrc_code like '12%' then '2��� else '3���� end desc) as l_rn,
c.c_proj_code ,
case when b.c_fdsrc_code like '11%' then '1ֱͶ when b.c_fdsrc_code like '12%' then '2��� else '3���� end as c_fdsource_name
from tt_tc_scale_inst_d a,dim_tc_fund_source b,dim_pb_project_basic c
where 
a.l_fdsrc_id = b.l_fdsrc_id 
and a.l_proj_id = c.l_proj_id
and C.C_PROJ_CODE = 'G224'
and a.l_day_id = 20160630;



-----------------------------------------------------------------���ű��	----------------------------------------------------------------
select t.c_proj_code,
       t.c_proj_name,
       c.c_dept_name,
       d.c_dept_name,
       t.l_effective_date
  from dim_pb_project_basic t,
       (select *
          from dim_pb_project_basic s
         where s.l_effective_flag = 0
           and substr(S.L_EXPIRATION_DATE, 1, 6) = 201606) b,
       dim_pb_department c,
       dim_pb_department d
 where substr(t.l_effective_date, 1, 6) = 201606
   and t.l_effective_flag = 1
   and t.l_dept_id = c.l_dept_id
   and b.l_dept_id = d.l_dept_id
   and t.c_proj_code = b.c_proj_code
   and t.l_dept_id <> b.l_dept_id;	

-----------------------------------------------------------------��������ϸ------------------------------------------------------------   
--���������š�ֱͶʩ�޵�   
SELECT sum(F_VALUE)
  FROM (SELECT b.c_proj_code,
               b.c_proj_name,
               round(sum(A.F_ACTUAL_EOT) / 10000, 2) AS F_VALUE
          FROM TT_SR_TSTREV_PROJ_M  A,
               DIM_PB_PROJECT_BASIC B,
               DIM_PB_PROJECT_BIZ   C
         WHERE A.L_PROJ_ID = B.L_PROJ_ID
           AND B.L_PROJ_ID = C.L_PROJ_ID
           AND SUBSTR(B.L_EFFECTIVE_DATE, 1, 6) <= A.L_MONTH_ID
           AND SUBSTR(B.L_EXPIRATION_DATE, 1, 6) > A.L_MONTH_ID
           AND B.C_PROJ_CODE <> 'E942'
           AND C.C_BUSI_SCOPE <> '3'
           and not exists
         (select 1
                  from tt_tc_fdsrc_proj_m   d,
                       dim_pb_project_basic e,
                       dim_tc_fund_source   f
                 where d.l_proj_id = e.l_proj_id
                   and d.l_fdsrc_id = f.l_fdsrc_id
                   and (f.c_fdsrc_code like '12%' or f.c_fdsrc_code = '113')
                   and b.c_proj_code = e.c_proj_code
                   and d.l_month_id = 201611)
           AND A.L_MONTH_ID = 201611
         group by b.c_proj_code, b.c_proj_name
        UNION ALL
        SELECT b.c_proj_code,
               b.c_proj_name,
               round(SUM(A.F_ACTUAL_EOT) / 10000, 2) AS F_VALUE
          FROM TT_SR_TSTREV_PROJ_M  A,
               DIM_PB_PROJECT_BASIC B,
               DIM_PB_PROJECT_BIZ   C
         WHERE A.L_PROJ_ID = B.L_PROJ_ID
           AND B.L_PROJ_ID = C.L_PROJ_ID
           AND SUBSTR(B.L_EFFECTIVE_DATE, 1, 6) <= A.L_MONTH_ID
           AND SUBSTR(B.L_EXPIRATION_DATE, 1, 6) > A.L_MONTH_ID
           AND (B.C_PROJ_CODE = 'E942' OR C.C_BUSI_SCOPE = '3')
           AND A.L_MONTH_ID = 201611
         group by b.c_proj_code, b.c_proj_name); 
        
--��ֵ����Ŀ            
SELECT b.c_proj_code,b.c_proj_name,SUM(A.F_ACTUAL_EOT) 
        FROM TT_SR_TSTREV_PROJ_M A,
               DIM_PB_PROJECT_BASIC B,
               DIM_PB_PROJECT_BIZ   C
         WHERE A.L_PROJ_ID = B.L_PROJ_ID
           AND B.L_PROJ_ID = C.L_PROJ_ID
           AND SUBSTR(B.L_EFFECTIVE_DATE,1,6) <= A.L_MONTH_ID
           AND SUBSTR(B.L_EXPIRATION_DATE,1,6) > A.L_MONTH_ID
           AND (B.C_PROJ_CODE = 'E942' OR C.C_BUSI_SCOPE = '3')
           AND B.L_EFFECTIVE_FLAG = 1
           AND A.L_MONTH_ID = 201606 
           group by b.c_proj_code,b.c_proj_name having sum(A.F_ACTUAL_EOT) <> 0;        
        
-----------------------------------------------------------------����������ʹ�ģ------------------------------------------------------------
--�������ʹ�ģ�������³���+�������
SELECT b.c_proj_code,b.c_proj_name,SUM(A.F_INCREASE_EOT) AS F_VALUE
  FROM TT_SR_SCALE_PROJ_M A, DIM_PB_PROJECT_BASIC B, DIM_PB_PROJECT_BIZ C
 WHERE A.L_PROJ_ID = B.L_PROJ_ID 
   AND B.L_PROJ_ID = C.L_PROJ_ID
   AND A.L_MONTH_ID >= SUBSTR(B.L_EFFECTIVE_DATE,1,6)
   AND A.L_MONTH_ID < SUBSTR(B.L_EXPIRATION_DATE,1,6)
   AND C.L_GRPREC_FLAG = 1 AND C.L_BANLKREC_SUB IS NOT NULL   
   AND (C.C_FUNC_TYPE = '1' OR
       (C.C_FUNC_TYPE = '3' AND C.C_AFFAIR_PROPS = '1'))
   AND EXISTS (SELECT 1
          FROM DIM_SR_STAGE D,DIM_PB_PROJECT_BASIC E
         WHERE E.L_PROJ_ID = D.L_PROJ_ID
           AND B.C_PROJ_CODE = E.C_PROJ_CODE
           AND D.L_EFFECTIVE_FLAG = 1
           AND SUBSTR(D.L_SETUP_DATE, 1, 4) = 2016)
   AND A.L_MONTH_ID = 201608
   group by b.c_proj_code,b.c_proj_name 
   order by b.c_proj_code,b.c_proj_name;

--��ѯ��Ŀ�Ƿ����Ƽ������ܷ��࣬��������
select t.c_proj_code,s.l_proj_id,s.l_grprec_flag,s.c_func_type,s.c_func_type_n,s.c_affair_props,s.c_affair_props_n 
from dim_pb_project_basic t,dim_pb_project_biz s 
where t.l_proj_id = s.l_proj_id 
and t.c_proj_name like '%�Ƚ�643%';

--�������ʹ�ģͳ�Ƹ����������������Ŀ��������ڲ���
SELECT b.c_proj_code,b.c_proj_name,d.c_inst_name,SUM(A.F_INCREASE_EOT) AS F_VALUE
  FROM TT_SR_SCALE_PROJ_M A, DIM_PB_PROJECT_BASIC B, DIM_PB_PROJECT_BIZ C,dim_pb_institution d
 WHERE A.L_PROJ_ID = B.L_PROJ_ID 
   AND B.L_PROJ_ID = C.L_PROJ_ID
  and c.l_bankrec_sub= d.l_inst_id
   AND A.L_MONTH_ID >= SUBSTR(B.L_EFFECTIVE_DATE,1,6)
   AND A.L_MONTH_ID < SUBSTR(B.L_EXPIRATION_DATE,1,6)
   AND C.L_GRPREC_FLAG = 1
   AND (C.C_FUNC_TYPE = '1' OR
       (C.C_FUNC_TYPE = '3' AND C.C_AFFAIR_PROPS = '1'))
   AND EXISTS (SELECT 1
          FROM DIM_SR_STAGE D,DIM_PB_PROJECT_BASIC E
         WHERE E.L_PROJ_ID = D.L_PROJ_ID
           AND B.C_PROJ_CODE = E.C_PROJ_CODE
           AND D.L_EFFECTIVE_FLAG = 1
           AND SUBSTR(D.L_SETUP_DATE, 1, 4) = 2016)
   AND A.L_MONTH_ID = 201611
   --and b.l_setup_date >= 20160101
   group by b.c_proj_code,b.c_proj_name,d.c_inst_name 
   order by b.c_proj_code,b.c_proj_name,d.c_inst_name;

-----------------------------------------------------------------���Ź�ģ------------------------------------------------------------
select b.l_dept_id, b.c_dept_name, sum(a.f_balance_eot)
  from tt_sr_scale_proj_m a, dim_pb_department b,dim_pb_project_basic c
 where c.l_dept_id = b.l_dept_id and a.l_proj_id = c.l_proj_id
   and a.l_month_id = 201606 
   and a.l_month_id >= substr(c.l_effective_date,1,6)
and a.l_month_id < substr(c.l_expiration_date, 1,6)
 group by b.l_dept_id, b.c_dept_name
 order by b.l_dept_id, b.c_dept_name;
 
--���в��ű�����
with temp_dept_change as
 (select a.l_proj_id,
         a.c_proj_code,
         a.c_proj_name,
         a.l_dept_id,
         b.c_dept_name,
         decode(a.l_effective_flag, 1, e.f_balance_eot, -1 * e.f_balance_eot) as f_balance_eot
    from dim_pb_project_basic a,
         dim_pb_department b,
         (select c_proj_code, l_dept_id, l_expiration_date
            from dim_pb_project_basic
           where substr(l_expiration_date, 1, 6) = 201608) c,
         (select c_proj_code, l_dept_id, l_effective_date
            from dim_pb_project_basic
           where substr(l_effective_date, 1, 6) = 201608) d,
         tt_sr_scale_proj_m e
   where a.l_dept_id = b.l_dept_id
     and a.c_proj_code = c.c_proj_code
     and a.c_proj_code = d.c_proj_code
     and c.l_dept_id <> d.l_dept_id
     and a.l_proj_id = e.l_proj_id
     and e.l_month_id = 201608
     and a.l_expiration_date >= 20160801),
--����ĩ���Ź�ģ
temp_dept_actual as
 (select a.l_dept_id,
         count(distinct case
                 when substr(nvl(a.l_expiry_date, 20991231), 1, 6) > t.l_month_id then
                  t.l_proj_id
                 else
                  null
               end) as l_count,
         sum(t.f_balance_eot) as f_exist
    from tt_sr_scale_proj_m t, dim_pb_project_basic a, dim_pb_currency b
   where t.l_proj_id = a.l_proj_id
     and a.l_cy_id = b.l_cy_id
     and t.l_month_id =
         to_char(add_months(To_Date('31-08-2016', 'dd-mm-yyyy'), -1),
                 'yyyymm')
     and substr(a.l_effective_date, 1, 6) <= t.l_month_id
     and substr(a.l_expiration_date, 1, 6) > t.l_month_id
     and b.c_cy_code = 'CNY'
   group by a.l_dept_id)
select temp_dept_actual.l_dept_id,
       temp_dept_actual.l_count,
       temp_dept_actual.f_exist + nvl(temp_dept_change.f_balance_eot, 0) as f_exist
  from temp_dept_actual, temp_dept_change
 where temp_dept_actual.l_dept_id = temp_dept_change.l_dept_id(+)

 
-----------------------------------------------------------------��������	------------------------------------------------------------ 
select T.L_OBJECT_ID, S.C_PROJ_CODE, s.c_proj_name, sum(t.f_actual_eot)
  from tt_pe_revenue_stage_m t, dim_pb_project_basic s
 where t.l_proj_id = s.l_proj_id
   and s.l_effective_flag = 1
   and t.l_object_id = 10
   and t.l_month_id = 201606 
   group by  T.L_OBJECT_ID, S.C_PROJ_CODE, s.c_proj_name having sum(t.f_actual_eot) <> 0 ;
   
--�����³���ģ����Ҫ�����е�������Ŀ������ȥ   
select a.l_proj_id,a.c_proj_code,a.c_proj_name,b.c_dept_name,decode(a.l_effective_flag,1,e.f_balance_eot,-1*e.f_balance_eot) as f_balance_eot
from dim_pb_project_basic a,
dim_pb_department b,
(select c_proj_code,l_dept_id,l_expiration_date from dim_pb_project_basic where substr(l_expiration_date,1,6) = 201608 ) c,
(select c_proj_code,l_dept_id,l_effective_date from dim_pb_project_basic where substr(l_effective_date,1,6) = 201608 ) d,
tt_sr_scale_proj_m e
where a.l_dept_id = b.l_dept_id
and a.c_proj_code = c.c_proj_code
and a.c_proj_code = d.c_proj_code 
and c.l_dept_id <> d.l_dept_id
and a.l_proj_id = e.l_proj_id
and e.l_month_id = 201608
and a.l_expiration_date >= 20160801;

-----------------------------------------------------------------��ϸ��ģ	------------------------------------------------------------ 
select c.c_proj_code,c.c_proj_Name,round(sum(a.f_incurred_eot)/100000000,4) 
from tt_sr_scale_type_m a,dim_pb_project_biz b ,dim_pb_project_basic c
where a.l_proj_id = b.l_proj_id and b.l_proj_id = c.l_proj_id
and b.l_valuation_flag = 1 
and  a.l_Month_id = 201607
and a.l_scatype_id = 2
group by c.c_proj_code,c.c_proj_Name 
order by c.c_proj_code,c.c_proj_Name;

select distinct t.c_proj_code,wmsys.wm_concat(t.c_fdsrc_name)over(partition by  t.c_proj_code order by t.l_fdsrc_id) from (
select s.c_proj_code,c.l_fdsrc_id,C.C_FDSRC_NAME,round(sum(t.f_scale)/10000,2)
from tt_tc_scale_flow_d t ,dim_tc_contract b,dim_pb_project_basic s ,dim_tc_fund_source c
where t.l_cont_id = b.l_cont_id 
and b.l_proj_id = s.l_proj_id
and nvl(b.l_fdsrc_Id,0) = c.l_fdsrc_id(+)
and t.l_change_date <= 20160930
and b.l_expiration_date >20160930
group by s.c_proj_code,c.l_fdsrc_id,C.C_FDSRC_NAME ) t;


-----------------------------------------------------------------�������Ź�ģ------------------------------------------------------------
--�������
select t3.c_dept_code,t3.c_dept_name,round(sum(t1.f_Scale_boy)/100000000,2)
from tt_pe_scale_type_m t1,dim_pb_project_basic t2,dim_pb_department t3
where t1.l_proj_id = t2.l_proj_id
and t1.l_object_id = t3.l_dept_id
and t1.l_month_id >= substr(t2.l_effective_date,1,6)
and t1.l_month_id < substr(t2.l_expiration_date, 1,6) and T1.L_MONTH_ID = 201610 and t1.l_scatype_id < 10
group by t3.c_dept_code,t3.c_dept_name order by t3.c_dept_code;

--������ģ
select t4.c_dept_code,t4.c_dept_name,
round(sum(case when t3.l_valuation_flag = 1 and t5.c_scatype_code = '02' then 0 else t1.f_scale_eot end)/100000000,2) as ����������ģ 
from tt_pe_scale_type_m t1,dim_pb_project_basic t2,dim_pb_project_biz t3,dim_pb_department t4,dim_sr_scale_type t5
where t1.l_proj_id = t2.l_proj_id
and t2.l_proj_id = t3.l_proj_id
and t1.l_object_id = t4.l_dept_id
and t1.l_scatype_id = t5.l_scatype_id
and t5.c_scatype_code in ('50','02')  
and t1.l_month_id >= substr(t2.l_effective_date,1,6)
and t1.l_month_id < substr(t2.l_expiration_date, 1,6) 
and T1.L_MONTH_ID = 201610
group by t4.c_dept_code,t4.c_dept_name order by t4.c_dept_code;

--�깺���
select t4.c_dept_code,t4.c_dept_name,
round(sum(case when t5.c_scatype_code in ('02','70') then t1.f_scale_eot else 0 end)/100000000,2) as �����깺��ģ, 
round(sum(case when t5.c_scatype_code in ('03','71') then t1.f_scale_eot else 0 end)/100000000,2) as ������ع�ģ
from tt_pe_scale_type_m t1,dim_pb_project_basic t2,dim_pb_project_biz t3,dim_pb_department t4,dim_sr_scale_type t5
where t1.l_proj_id = t2.l_proj_id
and t2.l_proj_id = t3.l_proj_id
and t1.l_object_id = t4.l_dept_id
and t1.l_scatype_id = t5.l_scatype_id
and t5.c_scatype_code in( '02','03','70','71')
and t3.l_valuation_flag = 1
and t1.l_month_id >= substr(t2.l_effective_date,1,6)
and t1.l_month_id < substr(t2.l_expiration_date, 1,6) 
and T1.L_MONTH_ID = 201610
group by t4.c_dept_code,t4.c_dept_name order by t4.c_dept_code;

--�����ģ
select t4.c_dept_code,t4.c_dept_name,
round(sum(t1.f_scale_eot)/100000000,2) as ���������ģ 
from tt_pe_scale_type_m t1,dim_pb_project_basic t2,dim_pb_project_biz t3,dim_pb_department t4,dim_sr_scale_type t5
where t1.l_proj_id = t2.l_proj_id
and t2.l_proj_id = t3.l_proj_id
and t1.l_object_id = t4.l_dept_id
and t1.l_scatype_id = t5.l_scatype_id
and t5.c_scatype_code in( '03')
and nvl(t2.l_expiry_date,209912331) between 20160101 and 20161031
and t1.l_month_id >= substr(t2.l_effective_date,1,6)
and t1.l_month_id < substr(t2.l_expiration_date, 1,6)
and T1.L_MONTH_ID = 201610
group by t4.c_dept_code,t4.c_dept_name order by t4.c_dept_code;

--�Ҹ���ģ
select a.c_dept_code,sum(-a-nvl(b,0)) from (
select t2.c_proj_code,t4.c_dept_code,
round(sum(t1.f_scale_eot)/100000000,2) as a 
from tt_pe_scale_type_m t1,dim_pb_project_basic t2,dim_pb_project_biz t3,dim_pb_department t4,dim_sr_scale_type t5
where t1.l_proj_id = t2.l_proj_id
and t2.l_proj_id = t3.l_proj_id
and t1.l_object_id = t4.l_dept_id
and t1.l_scatype_id = t5.l_scatype_id and t3.l_valuation_flag = 0
and t5.c_scatype_code in( '03','71')
and t1.l_month_id >= substr(t2.l_effective_date,1,6)
and t1.l_month_id < substr(t2.l_expiration_date, 1,6)
and T1.L_MONTH_ID = 201610 --and t4.c_dept_code = '0_80'
group by t2.c_proj_code,t4.c_dept_code)a,
(
select t2.c_proj_code,t4.c_dept_code,
round(sum(t1.f_scale_eot)/100000000,2) as b 
from tt_pe_scale_type_m t1,dim_pb_project_basic t2,dim_pb_project_biz t3,dim_pb_department t4,dim_sr_scale_type t5
where t1.l_proj_id = t2.l_proj_id
and t2.l_proj_id = t3.l_proj_id
and t1.l_object_id = t4.l_dept_id
and t1.l_scatype_id = t5.l_scatype_id and t3.l_valuation_flag = 0
and t5.c_scatype_code in( 'QS')
and nvl(t2.l_expiry_date,209912331) between 20160101 and 20161031
and t1.l_month_id >= substr(t2.l_effective_date,1,6)
and t1.l_month_id < substr(t2.l_expiration_date, 1,6) --and  t4.c_dept_code = '0_80'
and T1.L_MONTH_ID = 201610
group by t2.c_proj_code,t4.c_dept_code) b where a.C_proj_code = b.c_proj_code(+) group by a.c_dept_code order by a.c_dept_code;

--������ģ
select t4.c_dept_code,t4.c_dept_name,
round(sum(t1.f_scale_agg)/100000000,2) as ���������ģ 
from tt_pe_scale_type_m t1,dim_pb_project_basic t2,dim_pb_project_biz t3,dim_pb_department t4,dim_sr_scale_type t5
where t1.l_proj_id = t2.l_proj_id
and t2.l_proj_id = t3.l_proj_id
and t1.l_object_id = t4.l_dept_id
and t1.l_scatype_id = t5.l_scatype_id
and t5.c_scatype_class = 'XTHTGM'
and t1.l_month_id >= substr(t2.l_effective_date,1,6)
and t1.l_month_id < substr(t2.l_expiration_date, 1,6)
and T1.L_MONTH_ID = 201610
group by t4.c_dept_code,t4.c_dept_name order by t4.c_dept_code;

--��������ʽ�䶯
select s.c_proj_code,s.c_proj_name,c.c_fdsrc_name,d.c_inst_name,round(sum(t.f_scale)/10000,2)
from tt_tc_scale_flow_d t ,dim_tc_contract b,dim_pb_project_basic s ,dim_tc_fund_source c,dim_pb_institution d
where t.l_cont_id = b.l_cont_id 
and b.l_proj_id = s.l_proj_id 
and nvl(b.l_fdsrc_Id,0) = c.l_fdsrc_id(+)
and nvl(b.l_fdsrc_inst_id,0) = d.l_inst_id(+)
and t.l_change_date between 20161201 and 20161209
group by s.c_proj_code,s.c_proj_name,c.c_fdsrc_name,d.c_inst_name
order by s.c_proj_code,s.c_proj_name,c.c_fdsrc_name,d.c_inst_name;

--��Ŀ�ؼ�Ҫ��
select a.c_proj_code,
       a.c_proj_name,
       a.l_setup_date,
       a.l_preexp_date,
       a.l_expiry_date,
       a.c_proj_phase_n,
       a.c_proj_status_n,
       c.c_dept_name,
       c.c_dept_cate_n,
       b.c_manage_type_n,
       b.c_proj_type_n,
       b.c_func_type_n,
       b.c_special_type_n
  from dim_pb_project_basic a, dim_pb_project_biz b, dim_pb_department c
 where a.l_proj_id = b.l_proj_id
   and a.l_dept_id = c.l_dept_id
   and a.l_effective_flag = 1
   order by a.c_proj_phase;

--������Ŀ��ģ-������
select c.c_dept_cate_n,c.c_dept_name, sum(b.f_balance_agg)
  from dim_pb_project_basic   a,
       tt_to_operating_book_m b,
       dim_pb_department      c
 where a.l_proj_id = b.l_proj_id
   and a.l_dept_id = c.l_dept_id
   and b.l_month_id = 201611
   and b.f_balance_agg <> 0
   and a.l_effective_flag = 1
   and c.c_dept_cate = '04'--�к�̨ҵ����
 group by c.c_dept_cate_n,c.c_dept_name;

--������Ŀ����,��ģ
select b.c_special_type_n, count(*), sum(c.f_balance_agg) / 100000000
  from dim_pb_project_basic   a,
       dim_pb_project_biz     b,
       tt_to_operating_book_m c
 where a.l_proj_id = b.l_proj_id
   and a.l_proj_id = c.l_proj_id
   and c.l_month_id = 201611
   and a.l_effective_flag = 1
   and nvl(b.c_special_type, '99') <> '99'
 group by b.c_special_type_n;

--��˾���ָ��Ԥ��ֵ
select a.c_item_code,a.c_item_name, b.*
  from dim_pb_budget_item a, tt_pb_budget_y b
 where a.l_item_id = b.l_item_id
   and b.l_year_id = 2016;


--����
--�����ʲ�����
select t.c_status, count(t.l_count), sum(t.)
  from tt_project_summary t
 where t.l_dayid = to_number(to_char(trunc(sysdate), 'YYYYMMDD'))
 group by t.c_status;

--�����ʲ����ͺ˶�
Select a.l_monthid,
       b.c_projecttype,
       b.c_projecttypename,
       Sum(Case
             When a.f_balance_scale > 0 Then
              1
             Else
              0
           End) As f_count_exists,--��������
       Sum(a.f_balance_scale) As f_exists_scale,
       Sum(Case
             When a.f_new_inc_scale > 0 Then
              1
             Else
              0
           End) As f_count_new,
       Sum(a.f_new_inc_scale) As f_new_scale,
       Sum(Case
             When a.f_clear_scale > 0 Then
              1
             Else
              0
           End) As f_count_clear,
       Sum(a.f_clear_scale) As f_clear_scale,
       Sum(Case
             When a.f_clear_scale > 0 and
                 a.f_balance_scale = 0 Then
              1
             Else
              0
           End) As f_count_end,
       Sum(Case
             When a.f_clear_scale > 0 and
                  a.f_balance_scale = 0 Then
              a.f_clear_scale
             Else
              0
           End) As f_clear_end
  From tt_project_monthly a, dim_projectinfo b
 Where a.l_projectid = b.l_projectid
   And b.c_intrustflag = '1'
   And a.l_monthid = 201605
 Group By a.l_monthid, b.c_projecttype, b.c_projecttypename
 Order By a.l_monthid, b.c_projecttype, b.c_projecttypename;

--�����ʲ����ܷ���˶�
Select a.l_monthid,
       b.c_funtype,
       b.c_funtypename,
       Sum(Case
             When a.f_balance_scale > 0 Then
              1
             Else
              0
           End) As f_count_exists,
       Sum(a.f_balance_scale) As f_exists_scale,
       Sum(Case
             When a.f_new_inc_scale > 0 Then
              1
             Else
              0
           End) As f_count_new,
       Sum(a.f_new_inc_scale) As f_new_scale,
       Sum(Case
             When a.f_clear_scale > 0 Then
              1
             Else
              0
           End) As f_count_clear,
       Sum(a.f_clear_scale) As f_clear_scale,
       Sum(Case
             When a.f_clear_scale > 0 and
                  a.f_balance_scale = 0 Then
              1
             Else
              0
           End) As f_count_end,
       Sum(Case
             When a.f_clear_scale > 0 and
                  a.f_balance_scale = 0 Then
              a.f_clear_scale
             Else
              0
           End) As f_clear_end
  From tt_project_monthly a, dim_projectinfo b
 Where a.l_projectid = b.l_projectid
   And b.c_intrustflag = '1'
   And a.l_monthid = 201605
 Group By a.l_monthid, b.c_funtype, b.c_funtypename
 Order By a.l_monthid, b.c_funtype, b.c_funtypename;

--��Ŀ��Ϣ��ϸ
with temp_scale as
 (select t1.l_proj_id,
         t1.f_increase_eot,
         t1.f_decrease_eot,
         t1.f_balance_eot
    from tt_sr_scale_proj_m t1, dim_pb_project_basic t2
   where t1.l_proj_id = t2.l_proj_id
     and t1.l_month_id >= substr(t2.l_effective_date, 1, 6)
     and t1.l_month_id < substr(t2.l_expiration_date, 1, 6)
     and t1.l_month_id = 201609),
temp_revenue as
 (select t1.l_proj_id,
         sum(case when t1.l_revtype_id = 2 and t1.l_revstatus_id = 1 then t1.f_actual_eot else 0 end) as f_new_xtbc,
         sum(case when t1.l_revtype_id = 2 and t1.l_revstatus_id = 2 then t1.f_actual_eot else 0 end) as f_exist_xtbc,
         sum(case when t1.l_revtype_id = 4 and t1.l_revstatus_id = 1 then t1.f_actual_eot else 0 end) as f_new_xtcgf,
         sum(case when t1.l_revtype_id = 4 and t1.l_revstatus_id = 2 then t1.f_actual_eot else 0 end) as f_exist_xtcgf
    from tt_sr_tstrev_proj_m t1, dim_pb_project_basic t2
   where t1.l_proj_id = t2.l_proj_id
     and t1.l_month_id >= substr(t2.l_effective_date, 1, 6)
     and t1.l_month_id < substr(t2.l_expiration_date, 1, 6)
     and t1.l_month_id = 201609
   group by t1.l_proj_id),
temp_fa as
 (select t1.l_proj_id, t1.f_scale_eot,t1.f_scale_agg
    from tt_po_rate_proj_d t1, dim_pb_project_basic t2
   where t1.l_proj_id = t2.l_proj_id
     and t2.l_effective_flag = 1
     and t1.l_day_id = 20160930)
select a.c_proj_code as ��Ŀ����,
       a.c_proj_name as ��Ŀ����,
       c.c_dept_name as ���в���,
       g.c_emp_name  as ���о���
       a.c_proj_phase_n as ��Ŀ�׶�,
       a.c_proj_status_n as ��Ŀ״̬,
       a.l_setup_date as ��������,
       a.l_preexp_date as Ԥ��������,
       a.l_expiry_date as ��������,
       b.c_busi_scope_n as ҵ��Χ,
       b.c_proj_type_n as ��Ŀ����,
       --b.c_property_type_n as ��Ŀ�Ʋ�Ȩ����,
       b.c_func_type_n as ��������,
       --b.c_coop_type_n as ��������,
       b.c_trust_type_n as ��������,
       b.c_manage_type_n as ����ʽ,
       a.c_operating_way_n as ���з�ʽ,
       b.c_special_type_n as ����ҵ������,
       b.c_fduse_way_n as �ʽ����÷�ʽ,
       b.c_invest_indus_n as Ͷ����ҵ,
       b.c_invest_dir_n as Ͷ�ʷ���,
       --b.c_invest_way_n as Ͷ�ʷ�ʽ,
       d.f_increase_eot as ����������ģ,
       d.f_decrease_eot as ������ٹ�ģ,
       d.f_balance_eot as ��ǰ������ģ,
       f.f_scale_eot as FA�������й�ģ,
       f.f_scale_agg as FA�ۼ�ʵ�����й�ģ,
       e.f_new_xtbc as �������б���,
       e.f_exist_xtbc as �������б���,
       e.f_new_xtbc + e.f_exist_xtbc as �������б���,
       e.f_new_xtcgf as �������вƹ˷�,
       e.f_exist_xtcgf as �������вƹ˷�,
       e.f_new_xtcgf + e.f_exist_xtcgf as �������вƹ˷�
  from dim_pb_project_basic a,
       dim_pb_project_biz   b,
       dim_pb_department    c,
       temp_scale           d,
       temp_revenue         e,
       temp_fa              f,
       dim_pb_employee      g
 where a.l_proj_id = b.l_proj_id
   and a.l_dept_id = c.l_dept_id
   and a.l_tstmgr_id = g.l_emp_id
   and a.l_proj_id = d.l_proj_id(+)
   and a.l_proj_id = e.l_proj_id(+)
   and a.l_proj_id = f.l_proj_id(+)
   and a.l_effective_flag = 1
 order by a.l_setup_date;

--��Ŀ��ģ
select d.c_dept_name,
       e.c_emp_name,
       c.c_proj_code,
       c.c_proj_name,
       c.l_setup_date,
       c.l_expiry_date,
       round(a.f_balance_eot / 100000000, 4) as ��ģ
  from tt_sr_scale_proj_m   a,
       dim_pb_project_biz   b,
       dim_pb_project_basic c,
       dim_pb_department    d,
       dim_pb_employee      e
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = c.l_proj_id
   and c.l_dept_id = d.l_dept_id
   and c.l_tstmgr_id = e.l_emp_id
   and a.l_month_id >= substr(c.l_effective_date, 1, 6)
   and a.l_month_id < substr(c.l_expiration_date, 1, 6)
   and a.l_month_id = 201608
   and nvl(c.l_expiry_date, '20991231') > 20160831
 order by d.c_dept_name, e.c_emp_name, c.c_proj_code, c.c_proj_name;

