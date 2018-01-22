--�ڴι�ģ
create or replace view v_stage_scale_d as
with temp_bridge as
 (select t1.l_day_id, t1.l_stage_id, t1.f_scale_eot as f_bridge_eot
    from tt_sr_scale_type_d t1, dim_sr_scale_type t2
   where t1.l_scatype_id = t2.l_scatype_id
     and t2.c_scatype_code = '62')
select a.l_day_id       as ����,
       c.L_proj_id      as ��ĿID,
       c.c_Proj_code    as ��Ŀ����,
       b.l_stage_id     as �ڴ�ID,
       b.c_stage_code   as �ڴα���,
       a.f_increase_eot as ����������ģ,
       a.f_decrease_eot as ������ٹ�ģ,
       d.f_bridge_eot   as ������Ź�ģ,
       a.f_balance_eot  as ���꾻����ģ,
       a.f_balance_agg  as ��ģ���
  from tt_sr_scale_stage_d  a,
       dim_sr_stage         b,
       dim_pb_project_basic c,
       temp_bridge          d
 where a.l_stage_id = b.l_stage_id
   and b.l_proj_id = c.l_proj_id
   and a.l_day_id = d.l_day_id
   and a.l_stage_id = d.l_stage_id;
   
--�ڴ���������  
create or replace view v_stage_xtsr_d as
select a.l_day_id as ����,
       c.l_proj_id as ��ĿID,
       c.c_proj_code as ��Ŀ����,
       b.l_stage_id as �ڴ�ID,
       b.c_stage_code as �ڴα���,
       sum(decode(d.c_ietype_code, 'XTGDBC', a.f_actual_eoy, 0)) as ����֧���̶�����,
       sum(decode(d.c_ietype_code, 'XTGDBC', a.f_planned_eoy, 0)) as ����ȷ�Ϲ̶�����,
       sum(decode(d.c_ietype_code, 'XTFDBC', a.f_actual_eoy, 0)) as ����֧����������,
       sum(decode(d.c_ietype_code, 'XTFDBC', a.f_planned_eoy, 0)) as ����ȷ�ϸ�������,
       sum(decode(d.c_ietype_code, 'XTCGF', a.f_planned_eoy, 0)) as ����ȷ�ϲƹ˷�
  from tt_sr_ie_stage_d     a,
       dim_sr_stage         b,
       dim_pb_project_basic c,
       dim_pb_ie_type       d
 where a.l_stage_id = b.l_stage_id
   and b.l_proj_id = c.l_proj_id
   and a.l_ietype_id = d.l_ietype_id
 group by a.l_day_id,
          c.l_proj_id,
          c.c_proj_code,
          b.l_stage_id,
          b.c_stage_code;
          
--��Ӫ�û���
create or replace view v_proj_invest_d as
with temp_invest as
 (select a.l_day_id,
         a.l_proj_id,
         a.f_spent_agg,
         a.f_repay_agg,
         a.f_balance_agg
    from tt_sr_fund_stage_d a
   where a.l_stage_id = 0),
temp_tzsr as
 (select a.l_day_id,
         a.l_proj_id,
         sum(decode(b.c_ietype_code, 'TZZYFX', 0, a.f_planned_agg)) as f_tzsr,
         sum(decode(b.c_ietype_code, 'TZZYFX', a.f_planned_agg, 0)) as f_zyfx
    from tt_sr_ie_stage_d a, dim_pb_ie_type b
   where a.l_stage_id = 0
     and a.l_ietype_id = b.l_ietype_id
     and b.c_ietype_code_l1 = 'TZSR'
   group by a.l_day_id, a.l_proj_id)
select t1.l_day_id      as ����,
       t1.l_proj_id     as ��ĿID,
       t1.f_spent_agg   as �ۼ��ÿ�,
       t1.f_repay_agg   as �ۼƻ���,
       t1.f_balance_agg as ���,
       t2.f_tzsr        as Ͷ������,
       t2.f_zyfx        as ��Ӫ����
  from temp_invest t1, temp_tzsr t2
 where t1.l_day_id = t2.l_day_id
   and t1.l_proj_id = t2.l_proj_id;
   
--���ſ������
create or replace view v_dept_kpi_m as
with temp_scale as
 (select a.l_month_id, a.l_dept_id, a.f_balance_eot
    from tt_pe_scale_dept_m a),
temp_ie as
 (select b.l_month_id, b.l_dept_id, sum(b.f_planned_eoy) as f_planned_eoy
    from tt_pe_ie_dept_m b, dim_pb_ie_type b2
   where b.l_ietype_id = b2.l_ietype_id
     and b2.c_ietype_code_l1 in ('XTSR', 'TZSR')
   group by b.l_month_id, b.l_dept_id),
temp_budget as
 (select c.l_year_id,
         c.l_object_id,
         sum(decode(c2.c_item_code, 'BMZ001', c.f_budget, 0)) as f_scale_budget,
         sum(decode(c2.c_item_code, 'BMZ002', c.f_budget, 0)) as f_ie_budget
    from tt_pb_budget_y c, dim_pb_budget_item c2
   where c.l_item_id = c2.l_item_id
     and c2.c_item_code in ('BMZ001', 'BMZ002')
   group by c.l_year_id, c.l_object_id)
select t2.l_month_id    as �·�,
       t1.l_dept_id     as ����ID,
       t1.c_dept_code   as ���ű���,
       t1.c_dept_name   as ��������,
       t2.f_balance_eot as ������ģ,
       null             as Ԥ���ģ,
       t3.f_planned_eoy as �����ͬ����,
       null             as Ԥ������,
       null             as ������ö��,
       null             as �����˷���
  from dim_pb_department t1, temp_scale t2, temp_ie t3
 where t1.l_dept_id = t2.l_dept_id
   and t1.l_dept_id = t3.l_dept_id
   and t2.l_month_id = t3.l_month_Id;

--Ա���������
create or replace view v_emp_kpi_m as
with temp_scale as
 (select a.l_month_id, a.l_emp_id, a.f_balance_eot
    from tt_pe_scale_emp_m a),
temp_ie as
 (select b.l_month_id, b.l_emp_id, sum(b.f_planned_eoy) as f_planned_eoy
    from tt_pe_ie_emp_m b, dim_pb_ie_type b2
   where b.l_ietype_id = b2.l_ietype_id
     and b2.c_ietype_code_l1 in ('XTSR', 'TZSR')
   group by b.l_month_id, b.l_emp_id),
temp_budget as
 (select c.l_year_id,
         c.l_object_id,
         sum(decode(c2.c_item_code, 'BMZ001', c.f_budget, 0)) as f_scale_budget,
         sum(decode(c2.c_item_code, 'BMZ002', c.f_budget, 0)) as f_ie_budget
    from tt_pb_budget_y c, dim_pb_budget_item c2
   where c.l_item_id = c2.l_item_id
     and c2.c_item_code in ('BMZ001', 'BMZ002')
   group by c.l_year_id, c.l_object_id)
select t2.l_month_id    as �·�,
       t1.l_emp_id     as Ա��ID,
       t1.c_emp_code   as Ա������,
       t1.c_emp_name   as Ա������,
       t2.f_balance_eot as ������ģ,
       null             as Ԥ���ģ,
       t3.f_planned_eoy as �����ͬ����,
       null             as Ԥ������,
       null             as ������ö��,
       null             as �����˷���
  from dim_pb_employee t1, temp_scale t2, temp_ie t3
 where t1.l_emp_id = t2.l_emp_id
   and t1.l_emp_id = t3.l_emp_id
   and t2.l_month_id = t3.l_month_id;
