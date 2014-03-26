function switchvisibility(check)
   { if(!fileborrow.checked)
   {
   document.getElementById('borrower').style.visibility='hidden';
   document.getElementById('loaneddate').style.visibility='hidden';
   document.getElementById('returneddate').style.visibility='hidden';
   }
   else
   {
   document.getElementById('borrower').style.visibility='visible';
   document.getElementById('loaneddate').style.visibility='visible';
   document.getElementById('returneddate').style.visibility='visible';
   }
   }
