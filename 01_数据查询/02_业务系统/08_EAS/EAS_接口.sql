--��ƿ�Ŀ��
select t.c_id         as C_SUBID, --��ĿID
       t.c_number     as C_SUBCODE, --��Ŀ����
       t.c_name       as C_SUBNAME, --��Ŀ����
       t1.c_number    as L_CLASS, --��Ŀ����
       0              as C_FUNDID, --����ID
       t.f_dc         as L_BALDIR, --����
       t.f_level      as L_LEVEL, --��Ŀ����
       t.f_isleaf     as L_LEAF, --�Ƿ���ϸ
       t.c_currencyid as C_CYKIND, --���ִ���
       t.c_parentid   as C_FSUBCODE --������Ŀ
  from TS_EA_AccountView t, TS_EA_AccountType t1
 where t.c_accounttypeid = t1.c_id;

--ƾ֤��¼��
select t.c_id            as C_JOURID, --��¼ID
       t.c_billid        as C_VOUCHERID, --ƾ֤ID
       0                 as C_FUNDID, --����ID
       t1.d_bizdate      as D_BUSI, --ҵ������
       t1.c_description  as C_DIGEST, --ƾ֤ժҪ
       t.f_seq           as L_ROWID, --��¼��
       t2.c_number       as C_SUBCODE, --��Ŀ����
       t2.c_name         as C_SUBNAME, --��Ŀ����
       t.F_ENTRYDC       as L_BALDIR, --����
       0                 as F_DEBIT, --���ҽ跽
       0                 as F_CREDIT, --���Ҵ���
       t4.c_number       as C_CYKIND, --���ִ���
       null              as F_EXCH, --����
       null              as F_FOREIGN, --��ҽ��
       t1.f_bizstatus    as L_STATE, --ƾ֤״̬
       t3.f_periodyear   as L_YEAR, --������
       t3.f_periodnumber as L_MONTH, --����·�
       null              as C_COMBID --���ID
  from TS_EA_VoucherEnt  t,
       TS_EA_Voucher     t1,
       ts_ea_accountview t2,
       TS_EA_Period      t3,
       TS_EA_Currency    t4
 where t.c_billid = t1.c_id
   and t.c_accountid = t2.c_id
   and t1.c_periodid = t3.c_id
   and t.c_currencyid = t4.c_id;

--��������
select t.c_id     as C_CLASSID, --����ID
       t.c_number as C_CLASSNO, --������
       t.c_name   as C_CLASSNAME, --��������
       null       as C_FCLASSID, --����ID
       null       as C_REMARK --��ע
  from TS_EA_GeneralAsstActTypeGrp t;

--������Ϣ��
select t.c_id       as C_DEPTID, --����ID
       t.c_number   as C_DEPTCODE, --���ű��
       t.c_name     as C_DEPTNAME, --��������
       t.c_parentid as C_PARENTID, --�ϼ�����ID
       t.F_ISSTART  as C_ISVOID --�Ƿ�ʧЧ
  from TS_EA_Admin t;

--Ա����Ϣ
select t.fid          as C_STAFFID, --Ա��ID
       t1.c_id        as C_DEPTID, --��������ID
       t.fnumber      as C_STAFFCODE, --Ա����
       t.fname_l2     as C_STAFFNAME, --Ա������
       null           as C_IDTYPE, --֤������
       t.fidcardno    as C_IDCARD, --֤������
       null           as C_CTQCNO, --��ҵ�ʸ�֤��
       null           as C_POSTING, --ְ��
       null           as C_ISSENIOR, --�Ƿ�߹�
       null           as C_NOSTAFF, --�Ƿ��ޱ���
       t.fstate       as C_STATUS, --��ְ״̬
       t.fcell        as C_MOBILE, --�ֻ�
       t.fofficephone as C_TEL, --�绰
       t.femail       as C_EMAIL, --����
       null           as C_MSGMODE, --��Ϣ��ʽ
       null           as C_REMARK --��ע
  from TS_EA_Person t, TS_EA_admin t1
 where t.fHRORGUNITID = t1.c_id;

--��Ʒ��Ϣ

--�����˻�
select t.c_id                as C_ACCID, --�˻�ID
       t.c_name              as C_ACCNAME, --�ʻ�����
       t.c_bankaccountnumber as C_ACCNO, --�ʻ��˺�
       t1.c_name             as C_ORGNAME, --������������
       t.c_bank              as C_HEADBANKNO, --�������б��
       t.f_isclosed          as C_ISVOID --�Ƿ�ʧЧ
  from TS_EA_AccountBanks t, TS_EA_Company t1
 where t.c_companyid = t1.c_id;
