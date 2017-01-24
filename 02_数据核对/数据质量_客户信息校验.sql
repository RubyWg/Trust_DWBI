--�ͻ������Ϳͻ�����һ�£��Ҵ��ڿͻ���źϲ���
select a.c_custno, a.c_identitytype, b.c_custno, b.c_identitytype
  from tcustomerinfo a, tcustomerinfo b
 where (a.c_custtype = b.c_custtype and a.c_custname = b.c_custname)
   and a.c_custno <> b.c_custno
   and exists (select 1
          from tcommon_merge c
         where b.c_custno = c.c_custnocurr
           and a.c_custno = c.c_custnoold);

--��Ҫ��һ��֤�����Ͳ�һ�����ҳ��ֹ��ϲ��Ŀͻ�
select a.c_custno, a.c_identitytype, b.c_custno, b.c_identitytype
  from tcustomerinfo a, tcustomerinfo b
 where (a.c_custtype = b.c_custtype and a.c_custname = b.c_custname and
       a.c_identityno = b.c_identityno and
       a.c_identitytype <> b.c_identitytype)
   and exists (select 1
          from tcommon_merge c
         where b.c_custno = c.c_custnocurr
           and a.c_custno = c.c_custnoold);

--��Ҫ��һ��֤�����벻һ�����ҳ��ֹ��ϲ��Ŀͻ�
select a.c_custno, a.c_identitytype, b.c_custno, b.c_identitytype
  from tcustomerinfo a, tcustomerinfo b
 where (a.c_custtype = b.c_custtype and a.c_custname = b.c_custname and
       a.c_identityno <> b.c_identityno and
       a.c_identitytype = b.c_identitytype)
   and exists (select 1
          from tcommon_merge c
         where b.c_custno = c.c_custnocurr
           and a.c_custno = c.c_custnoold);