:javascript
  function switchvisibility(el) {
    if (document.getElementById(el).checked) {
      document.getElementById('borrower').style.display = "table-row";
      document.getElementById('loaneddate').style.display = "table-row";
      document.getElementById('returneddate').style.display = "table-row";
    } else {
      document.getElementById('borrower').style.display = "none";
      document.getElementById('loaneddate').style.display = "none";
      document.getElementById('returneddate').style.display = "none";
    }
  }
  