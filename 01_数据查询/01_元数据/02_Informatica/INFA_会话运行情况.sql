--�鿴�Ự��������־
select c.task_name         as ��������,
       b.start_time        as ��ʼʱ��,
       b.end_time          as ����ʱ��,
       a.mapping_name      as �Ự����,
       a.src_success_rows  as Դ��ȡ�ɹ���¼��,
       a.src_failed_rows   as Դ��ȡʧ�ܼ�¼��,
       a.targ_success_rows as Ŀ����سɹ���¼��,
       a.targ_failed_rows  as Ŀ�����ʧ�ܼ�¼��,
       a.first_error_msg   as ������Ϣ
  from opb_sess_task_log a, opb_wflow_run b, opb_task c
 where a.workflow_run_id = b.workflow_run_id
   and b.workflow_id = c.task_id
   and c.task_type = 71
   and a.mapping_name in( 'm_ts_hsfa_vouchers_ful','m_tdc_fa_vouchers_ful')
   order by b.start_time desc,a.mapping_name;