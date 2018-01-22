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
