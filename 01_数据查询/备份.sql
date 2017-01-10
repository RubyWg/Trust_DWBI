 
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


/********************************************************************************************************************************************/


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
   
--������ģ�ϼ�
select sum(a.f_balance_eot) / 100000000
  from tt_sr_scale_proj_m a, dim_pb_project_biz b, dim_pb_project_basic c
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = c.l_proj_id
   and a.l_month_id >= substr(c.l_effective_date, 1, 6)
   and a.l_month_id < substr(c.l_expiration_date, 1, 6)
   and a.l_month_id = 201606
   and nvl(c.l_expiry_date, '20991231') > 20160630;

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

--�����ģ
select t4.c_dept_code,
       t4.c_dept_name,
       round(sum(t1.f_scale_eot) / 100000000, 2) as ���������ģ
  from tt_pe_scale_type_m   t1,
       dim_pb_project_basic t2,
       dim_pb_project_biz   t3,
       dim_pb_department    t4,
       dim_sr_scale_type    t5
 where t1.l_proj_id = t2.l_proj_id
   and t2.l_proj_id = t3.l_proj_id
   and t1.l_object_id = t4.l_dept_id
   and t1.l_scatype_id = t5.l_scatype_id
   and t5.c_scatype_code in ('03')
   and nvl(t2.l_expiry_date, 209912331) between 20160101 and 20161031
   and t1.l_month_id >= substr(t2.l_effective_date, 1, 6)
   and t1.l_month_id < substr(t2.l_expiration_date, 1, 6)
   and T1.L_MONTH_ID = 201610
 group by t4.c_dept_code, t4.c_dept_name
 order by t4.c_dept_code;

--�깺���
select t4.c_dept_code, t4.c_dept_name,
round(sum(case when t5.c_scatype_code in ('02','70') then t1.f_scale_eot else 0 end)/100000000,2) as �����깺��ģ, 
round(sum(case when t5.c_scatype_code in ('03','71') then t1.f_scale_eot else 0 end)/100000000,2) as ������ع�ģ
  from tt_pe_scale_type_m   t1,
       dim_pb_project_basic t2,
       dim_pb_project_biz   t3,
       dim_pb_department    t4,
       dim_sr_scale_type    t5
 where t1.l_proj_id = t2.l_proj_id
   and t2.l_proj_id = t3.l_proj_id
   and t1.l_object_id = t4.l_dept_id
   and t1.l_scatype_id = t5.l_scatype_id
   and t5.c_scatype_code in ('02', '03', '70', '71')
   and t3.l_valuation_flag = 1
   and t1.l_month_id >= substr(t2.l_effective_date, 1, 6)
   and t1.l_month_id < substr(t2.l_expiration_date, 1, 6)
   and T1.L_MONTH_ID = 201610
 group by t4.c_dept_code, t4.c_dept_name
 order by t4.c_dept_code;
 
--�Ҹ���ģ
--JYXT
select a.c_dept_code, sum(-a - nvl(b, 0))
  from (select t2.c_proj_code,
               t4.c_dept_code,
               round(sum(t1.f_scale_eot) / 100000000, 2) as a
          from tt_pe_scale_type_m   t1,
               dim_pb_project_basic t2,
               dim_pb_project_biz   t3,
               dim_pb_department    t4,
               dim_sr_scale_type    t5
         where t1.l_proj_id = t2.l_proj_id
           and t2.l_proj_id = t3.l_proj_id
           and t1.l_object_id = t4.l_dept_id
           and t1.l_scatype_id = t5.l_scatype_id
           and t3.l_valuation_flag = 0
           and t5.c_scatype_code in ('03', '71')
           and t1.l_month_id >= substr(t2.l_effective_date, 1, 6)
           and t1.l_month_id < substr(t2.l_expiration_date, 1, 6)
           and T1.L_MONTH_ID = 201610 --and t4.c_dept_code = '0_80'
         group by t2.c_proj_code, t4.c_dept_code) a,
       (select t2.c_proj_code,
               t4.c_dept_code,
               round(sum(t1.f_scale_eot) / 100000000, 2) as b
          from tt_pe_scale_type_m   t1,
               dim_pb_project_basic t2,
               dim_pb_project_biz   t3,
               dim_pb_department    t4,
               dim_sr_scale_type    t5
         where t1.l_proj_id = t2.l_proj_id
           and t2.l_proj_id = t3.l_proj_id
           and t1.l_object_id = t4.l_dept_id
           and t1.l_scatype_id = t5.l_scatype_id
           and t3.l_valuation_flag = 0
           and t5.c_scatype_code in ('QS')
           and nvl(t2.l_expiry_date, 209912331) between 20160101 and
               20161031
           and t1.l_month_id >= substr(t2.l_effective_date, 1, 6)
           and t1.l_month_id < substr(t2.l_expiration_date, 1, 6) --and  t4.c_dept_code = '0_80'
           and T1.L_MONTH_ID = 201610
         group by t2.c_proj_code, t4.c_dept_code) b
 where a.C_proj_code = b.c_proj_code(+)
 group by a.c_dept_code
 order by a.c_dept_code;
