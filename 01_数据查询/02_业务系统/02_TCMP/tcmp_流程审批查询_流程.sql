--������Ϣ
select distinct t.c_agentname from TFLOWINFO t where t.l_flowinfoid = 17458;

select * from tflowinfo t where t.c_projectcode = 'D062' and t.process_instanceid like 'projectChange%';

--���̸���
select * from TFLOWATTACH t where t.c_processinstanceid = 'projectChange.490712';

--����������¼
select * from TFLOWAPPROVES t where t.c_processinstanceid = 'projectChange.490712';

--�����漰�ı�
select * from TACCOUNT_BANK_APPLY;--�����˻�����
select * from TACCOUNT_CAPITAL_APPLY;--�����ʽ�����
select * from TBENIFICAIARY_TRANSFER_INFO;--����Ȩת������
select * from TCAPITAL_TRANSFER_INFO;--�ʽ�����Ϣ
select * from TFLOWINFO_TEXT;--�����ı�����
select * from TPROJECT_CONTRACT;--��Ŀ��ͬ
select * from TPROJECT_DISCLOSURE_APPROVAL;--��¶����ʱ����
select * from TPROJECT_DIVIDESCHEME;--��Ŀ�ֳɣ���ʱ����
select * from TPROJECT_FACTOR_TRACE;--��ĿҪ��--����Ҫ
select * from TPROJECT_FILE_BILL;--��Ŀ�ļ�֮��ģ�Ӧ������
select * from TPROJECT_INFO;--��Ŀ
select * from TPROJECT_LIQUIDATION_INFO;--��������ã�Ӧ��û�õ�
select * from TRISK_COLLATERAL;--���յ���Ʒ��Ӧ������
select * from TRISK_COLLATERALOUT;--����յ������
