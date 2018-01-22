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
