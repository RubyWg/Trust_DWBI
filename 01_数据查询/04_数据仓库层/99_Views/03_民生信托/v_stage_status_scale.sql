create or replace view v_stage_status_scale as
select t.l_day_id,
       t.l_proj_id,
       t.l_stage_id,
       sum(nvl(t.f_increase_eot,0)) f_increase_eot, --��������
       sum(nvl(t.f_balacne_bot,0))  f_balacne_bot, --��ǰ����
       sum(nvl(t.f_decrease_eot,0)) f_decrease_eot, --�����ģ
       --������� = ��������-��������-��ǰ����
       sum((t.f_increase_eot - t.f_decrease_eot - t.f_balacne_bot) * -1) f_beginyear_scale--�������
  from tt_sr_scale_stage_d t
  group by t.l_day_id,
           t.l_proj_id,
           t.l_stage_id;
