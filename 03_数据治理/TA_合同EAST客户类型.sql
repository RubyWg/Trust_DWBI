
--������к�ͬ�е�c_eastcusttype�ֶν���������죻
--���ί����ʵ��Ϊ���еȽ��ڻ�������EAST�ͻ�����ԭ���ϲ�Ӧ��Ϊ0�����ǽ��ڻ�����
select b.c_tano         as ����˺�,
       b.c_clientname   as ί��������,
       b.c_clientkind   as ί��������,
       b.c_idtype       as ֤������,
       b.c_idcard       as ֤������,
       a.l_serialno     as ��ͬ���к�,
       a.c_eastcusttype as east�ͻ�����--0����ͨ����,�ǽ��ڻ����͸�����������ʽ�
  from ttrustcontractdetails a, hstdc.cm_client b
 where a.c_fundacco = b.c_tano
   and (b.c_clientname like '%����%' or b.c_clientname like '%����%' or b.c_clientname like '%����%' or b.c_clientname like '%����%')
   and exists (select 1
          from ttrustcontractdetails c
         where a.l_serialno = c.l_serialno
           and c.c_eastcusttype = '0');

--������ί���ˣ����ְ������л������ģ����ʽ���Դ��������ƻ��������е�		   
select b.c_tano         as ����˺�,
       b.c_clientname   as ί��������,
       b.c_clientkind   as ί��������,
       b.c_idtype       as ֤������,
       b.c_idcard       as ֤������,
       a.l_serialno     as ��ͬ���к�,
       a.c_eastcusttype as east�ͻ�����--0����ͨ����,�ǽ��ڻ����͸�����������ʽ�
  from ttrustcontractdetails a, hstdc.cm_client b
 where a.c_fundacco = b.c_tano
   and (b.c_clientname not like '%����%' and b.c_clientname not like '%����%��%' )
   and exists (select 1
          from ttrustcontractdetails c
         where a.l_serialno = c.l_serialno
           and c.c_eastcusttype in ('2','3'));