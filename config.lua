local accountBL = IMAP {
    server = 'XXXXX',
    username = 'XXXXX',
    password = 'XXXXX',
    ssl = 'ssl3',
}

-- Get the status of a mailbox
accountBL.INBOX:check_status()

-- Get all the messages in the mailbox.
results = accountBL.INBOX:select_all()

--------------------------
---------- filters -------
--------------------------


-- team + staff
results = accountBL.INBOX:is_unseen() *
         (
          accountBL.INBOX:contain_from('@staff.blueline.mg')
         )
results:move_messages(accountBL['8-staff-blueline'])

results = accountBL.INBOX:is_unseen() *
         (
          accountBL.INBOX:contain_from('@gulfsat.mg') -
          accountBL.INBOX:contain_subject('[Panne-system #')
         )
results:move_messages(accountBL['team'])

-- tasks
results = accountBL.INBOX:is_unseen() *
         (
          accountBL.INBOX:contain_subject('[DS #') +
          accountBL.INBOX:contain_subject('[Panne-system #')
         )
results:move_messages(accountBL['3-tasks'])

-- NDR
results = accountBL.INBOX:is_unseen() *
         (
          accountBL.INBOX:contain_subject('Undelivered Mail Returned to Sender') +
          accountBL.INBOX:contain_subject('Mail delivery failed: returning message to sender')
         )
results:move_messages(accountBL['NDR'])

-- cron and noisy e-mails
results = accountBL.INBOX:is_unseen() *
         (
          accountBL.INBOX:contain_subject('Cron <root@bw') +
          accountBL.INBOX:contain_subject('Cron <root@rtr') +
          accountBL.INBOX:contain_subject('Cron <root@dektec') +   
          accountBL.INBOX:contain_subject('Cron <root@lte-') +
          accountBL.INBOX:contain_subject('Cron <root@wimax-') +
          accountBL.INBOX:contain_subject('Cron <root@blpr') +
          accountBL.INBOX:contain_subject('Cron <root@bldv') +
          accountBL.INBOX:contain_subject('/usr/sbin/apticron') +
          accountBL.INBOX:contain_subject('Cron <root@srv-graphe-mrtg> /usr/local/bin/noplan') +
          accountBL.INBOX:contain_subject('[Root-sysadmin] Cron <root@srv-capacityp') +
          accountBL.INBOX:contain_subject('if [ -x /usr/bin/munin-cron ]; then /usr/bin/munin-cron') +
          accountBL.INBOX:contain_subject('[Root-sysadmin] changed ethernet address') +
          accountBL.INBOX:contain_subject('Debian package update(s) for ')    
         )  - 
          accountBL.INBOX:contain_subject('[AS]')
results:move_messages(accountBL.Archives)

-- monitoring and noisy e-mails
results = accountBL.INBOX:is_unseen() *
         (
          accountBL.INBOX:contain_from('monitoring@blueline.mg') +
          accountBL.INBOX:contain_subject('[AS] [ début ] ') +
          accountBL.INBOX:contain_subject('[AS] [ fin ] ') +   
          accountBL.INBOX:contain_subject('[AS] [ en cours ]')
         )
results:move_messages(accountBL['11-monitoring'])

-- sysadmin
results = accountBL.INBOX:is_unseen() *
         (
          accountBL.INBOX:contain_subject('[AS]') +
          accountBL.INBOX:contain_subject('[Root-sysadmin]')
         )
results:move_messages(accountBL['1-sys-adm'])
