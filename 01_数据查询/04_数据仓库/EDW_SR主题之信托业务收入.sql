--��������
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

--��Ŀ���б���
select d.c_proj_code as ��Ŀ����,
       d.c_proj_name as ��Ŀ����,
       d.l_setup_date as ��������,
       d.c_Proj_Phase_n as ��Ŀ�׶�,
       e.c_dept_name as ��������,
       b.c_ietype_name as ��������,
       sum(a.f_actual_agg) as �ۼ�ʵ������,
       sum(a.f_planned_agg) as �ۼƼƻ�����,
       sum(a.f_planned_agg - a.f_actual_agg) as �ۼ�δ��������
  from tt_ic_ie_party_m     a,
       dim_pb_ie_type       b,
       dim_pb_project_basic d,
       dim_pb_department    e
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
          b.c_ietype_name
having sum(a.f_planned_agg - a.f_actual_agg) < 0
 order by e.c_dept_name, d.c_proj_phase_n, d.l_setup_date;

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
 
--����ҵ�����밴ҵ��Χ����Ŀ���͡����ܷ��ࡢ��������
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
 group by c.c_busi_scope,
          c.c_busi_scope_n,
          c.c_proj_type,
          c.c_proj_type_n,
          c.c_func_type,
          c.c_func_type_n,
          c.c_affair_props,
          c.c_affair_props_n
having round(sum(a.f_planned_eot) / 10000, 2) <> 0
 order by c.c_busi_scope, c.c_proj_type, c.c_func_type, c.c_affair_props;
 
--����ҵ�����밴��Ŀ����
select c.c_proj_type_n, sum(a.f_planned_eot) / 10000
  from tt_sr_tstrev_proj_m a, dim_pb_project_basic b, dim_pb_project_biz c
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = C.L_PROJ_ID
   and a.l_month_id >= substr(b.l_effective_date, 1, 6)
   and a.l_month_id < substr(b.l_expiration_date, 1, 6)
   and a.l_month_id = 201606
 group by c.c_proj_type_n;
 
--����ҵ�����밴����״̬
select A.L_REVSTATUS_ID, sum(a.f_actual_eot) / 10000
  from tt_sr_tstrev_proj_m a, dim_pb_project_basic b
 where a.l_proj_id = b.l_proj_id
   and a.l_month_id >= substr(b.l_effective_date, 1, 6)
   and a.l_month_id < substr(b.l_expiration_date, 1, 6)
   and a.l_month_id = 201606
 group by A.L_REVSTATUS_ID;