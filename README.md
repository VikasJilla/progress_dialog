# progress_dialog

A Simple and easy to use flutter package for showing progress bar.


#Usage

Import the package
```
import 'package:custom_progress_dialog/custom_progress_dialog.dart';
```


Create an object for ProgressDialog class
```
ProgressDialog _progressDialog = ProgressDialog();
```

showing progress dialog

```
_progressDialog.showProgressDialog(context,dismissAfter: Duration(seconds: 5),textToBeDisplayed:'Sending...',onDismiss:(){
	//things to do after dismissing -- optional
});
dismissAfter - if null then progress dialog won't dismiss until dismissProgressDialog is called from the code.
```

dismiss progressDialog

```
_progressDialog.dismissProgressDialog(context);
```

## Preview:

![](example/images/pdialog.gif)
