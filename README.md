# progress_dialog

A Simple and easy to use flutter package for showing progress bar.


#Usage
//Create an object for ProgressDialog class
```ProgressDialog _progressDialog = ProgressDialog();

 //showing progress dialog
```_progressDialog.showProgressDialog(context,dismissAfter: Duration(seconds: 5),textToBeDisplayed:'Sending...',onDismiss:(){
	//things to do after dismissing -- optional
});

//dismiss progressDialog
```_progressDialog.dismissProgressDialog(context);