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


--select * from JBPM4_DEMO_CUSTOMER;
--select * from JBPM4_DEPLOYPROP;
--select * from JBPM4_EXT_CONFIG;
--select * from JBPM4_EXT_FORM_RESREG;
--select * from JBPM4_EXT_FORM_RESSTATUS;
--select * from JBPM4_EXT_LOG;
--select * from JBPM4_EXT_MWTEMPLATE;
--select * from JBPM4_EXT_NODE_FIELDS;
--select * from JBPM4_EXT_PROCINST;
--select * from JBPM4_EXT_PRO_VER;
--select * from JBPM4_EXT_TASK_CTL;
--select * from JBPM4_EXT_TRACE;
--select * from JBPM4_EXT_VERSION_CONTEXTFIELD;
--select * from JBPM4_EXT_VER_DEP;
--select * from JBPM4_FORMTEXT_DEMO;
--select * from JBPM4_FORMTEXT_LEAVE;
--select * from JBPM4_HIST_DETAIL;
--select * from JBPM4_HS_TASK;
--select * from JBPM4_ID_GROUP;
--select * from JBPM4_ID_MEMBERSHIP;
--select * from JBPM4_ID_USER;
--select * from JBPM4_JOB;
--select * from JBPM4_LOB;
--select * from JBPM4_PROPERTY;
--select * from JBPM4_SWIMLANE;

select * from JBPM4_EXT_PRO;--����
select * from JBPM4_EXT_PROCESS_TYPE;--��������
select * from JBPM4_EXT_PT_TRAN;--�ǳ���Ҫ


select * from JBPM4_HIST_PROCINST;--���������ʵ��
select * from JBPM4_HIST_TASK t ;--ʵ����������񣬰�����ʷ
select * from JBPM4_TASK t;

select * from JBPM4_EXT_HIST_TASK;--ʵ�����������
select * from JBPM4_HIST_VAR;--ʵ�������ı���

select * from JBPM4_EXT_START;--ʵ������

select * from JBPM4_EXT_TASKDEF_DETAIL;--�ǳ���Ҫ

select * from JBPM4_PARTICIPATION;--��Ҫ
select * from JBPM4_VARIABLE;--��Ҫ

select * from JBPM4_EXT_NOTICE;--֪ͨ
select * from JBPM4_EXT_NOTICE_RECIVER;--֪ͨ������
select * from JBPM4_EXT_NOTICE_STATUS;--֪ͨ״̬

select * from JBPM4_DEPLOYMENT;--����
select * from JBPM4_EXECUTION;
select * from JBPM4_EXT_COMBOBOX_;
select * from JBPM4_EXT_DELEGATE;--ָ��
select * from JBPM4_EXT_DELEGATE_DETAIL;--ָ����ϸ

select * from JBPM4_EXT_EXP;
select * from JBPM4_EXT_FORMCLASS;
select * from JBPM4_EXT_FORMREG;

select * from JBPM4_EXT_TEMPLATE_DATA;
select * from JBPM4_EXT_VER;
select * from JBPM4_EXT_VER_OPR;--
select * from JBPM4_HIST_ACTINST;--���ϸ

select * from JBPM4_EXT_PROC_EDITOR;
select * from JBPM4_EXT_SERVICEREG;
select * from JBPM4_EXT_SERVICE_ERROR;
select * from JBPM4_EXT_SERVICE_FORM;
select * from JBPM4_EXT_SERVICE_PARA_IN;
select * from JBPM4_EXT_SERVICE_PARA_OUT;
