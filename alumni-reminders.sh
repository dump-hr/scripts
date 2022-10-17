#!/bin/sh

alumni=$1

echo "Poruka:"
echo "Pozdrav :wave:"
echo "Kako danas kreće proces tvog prelaska u DUMP aluminija, moram te obavijestiti:"
echo "Danas ćes tvoj email bit uklonjen iz mail distribucijskih listi i dodan na alumni@dump.hr (javi danas EOD ako misliš da je potrebno da ipak ostaneš u nekoj)"
echo "Pristup Bitwardenu će ti biti uklonjen danas"
echo "Pristup Google Driveu, VPNu, Clickupu i Githubu će ti biti uklonjen za 30 dana"
echo "Slack će ti bit djelomicno uklonjen nakon 90 dana (ostat ćes samo u #alumni kanalu, ako želiš ostat u još nekom, slobodno javi)"
echo "Ako sam nešto zaboravio a imaš pristup bilo bi lipo da javiš!"
echo "EOM"

echo "Reminders:"
echo "/remind \"ukloni bitwarden, distribucijske liste i dodaj u alumni@dump.hr (@$alumni)\" tomorrow"
echo "/remind \"ukloni google drive, vpn, clickup i github (@$alumni)\" in 30 days"
echo "/remind \"ukloni slack (@$alumni)\" in 90 days"
echo "/remind @$alumni \"za 7 dana bit će ti uklonjen pristup za google drive, vpn, clickup i github. nemoj zaboraviti backupirati stvari koje su ti bitne\" in 23 days"
echo "/remind @$alumni \"sutra će ti bit uklonjen pristup za google drive, vpn, clickup i github. nemoj zaboraviti backupirati stvari koje su ti bitne\" in 29 days"
echo "/remind @$alumni \"za 7 dana bit će ti uklonjen pristup većini kanala na slacku\" in 83 days"
echo "/remind @$alumni \"sutra će ti bit uklonjen pristup većini kanala na slacku\" in 89 days"
