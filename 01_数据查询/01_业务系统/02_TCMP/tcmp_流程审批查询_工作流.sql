--��������
select t.*, SYS_CONNECT_BY_PATH(t.type_name, '|') || '|' C_PATH
  from JBPM4_EXT_PROCESS_TYPE t
 start with t.parent_id = 0
connect by prior t.dbid_ = t.parent_id;

--������Ϣ
select t2.type_name,t1.* from JBPM4_EXT_PRO t1,JBPM4_EXT_PROCESS_TYPE t2 where t1.type_id = t2.dbid_ and t1.type_id = '434372';

--���̰�����ʵ������version����
select * from JBPM4_EXT_TASKDEF_DETAIL t where t.process_key_ = 'projectEvaluation2' and t.version_no_ = 106;

--���̵��ȣ��ݲ������ʵ���Ĺ�ϵ
select * from JBPM4_DEPLOYMENT t where t.process_key_ = 'projectEvaluation2' --t.dbid_ = '410231';

select * from JBPM4_EXECUTION t where t.procdefid_ like 'projectEvaluation2%';

--ʵ����Ϣ
select * from JBPM4_HIST_PROCINST t where t.procdefid_ = 'projectEvaluation2-37' order by t.start_;

--ʵ����������״̬����jbpm4_ext_hist_task�����ص����ɲ���
select * from JBPM4_EXT_START t where t.process_instance_ = 'projectEvaluation2.411951';
--ʵ�����������ִ�����
select t1.*
  from jbpm4_hist_task t, jbpm4_ext_hist_task t1
 where t.procinst_ = '411951'
   and t.dbid_ = t1.dbid_
 order by to_char(t.create_, 'yyyymmdd');
 
select * from jbpm4_hist_task t where t.procinst_ = '411951';

--�����task id �޷�����
select * from JBPM4_PARTICIPATION t where t.task_ = '411961';
select * from JBPM4_VARIABLE;

--����������
select * from JBPM4_EXT_DETAILS;--5

--�����process_id�������ʲô����������JBPM4_EXT_PRO���ڵ����ݲ�һ��
select * from JBPM4_EXT_PT_TRAN t where t.type_id = '60011';

select * from JBPM4_EXT_DELEGATE_DETAIL t where t.process_key_ = 'projectEvaluation2';
select * from JBPM4_EXT_DELEGATE t where t.dbid_ in (select t1.delegate_id_ from JBPM4_EXT_DELEGATE_DETAIL t1 where t1.process_key_ = 'projectEvaluation2');--ָ��
