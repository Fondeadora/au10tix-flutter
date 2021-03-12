package com.fondeadora.au10tix_flutter.views.fragments

import android.Manifest
import android.app.ProgressDialog
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.os.Bundle
import android.view.View
import androidx.appcompat.app.AlertDialog
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import com.au10tix.faceliveness.FaceLivenessResult
import com.au10tix.sdk.core.PermissionManager
import com.au10tix.sdk.protocol.FeatureSessionResult
import com.au10tix.smartDocument.SmartDocumentResult
import java.util.*

abstract class BaseFragment : Fragment() {
    //lateinit var viewModel: DataViewModel

    protected var pDialog: ProgressDialog? = null
    private var alertDialog: AlertDialog? = null


    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        //viewModel = ViewModelProvider(requireActivity()).get(
        //    DataViewModel::class.java
        //)
    }

    protected open val requiredPermissions: Array<String?>
        protected get() = arrayOf(
            Manifest.permission.CAMERA,
            Manifest.permission.ACCESS_COARSE_LOCATION,
            Manifest.permission.ACCESS_FINE_LOCATION
        )

    protected open fun startCore() {}
    protected fun verifyPermissions(): Boolean {
        val missingPermissions = ArrayList<String?>()
        for (requiredPermission in requiredPermissions) {
            if (!PermissionManager.verifyPermissionGranted(context, requiredPermission)) {
                missingPermissions.add(requiredPermission)
            }
        }
        if (!missingPermissions.isEmpty()) {
            val missingPermissionArray = missingPermissions.toTypedArray()
            requestPermissions(missingPermissionArray, PERMISSIONS_RQ)
            return false
        }
        return true
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == PERMISSIONS_RQ) {
            for (permissionGrantState in grantResults) {
                if (permissionGrantState == PackageManager.PERMISSION_DENIED) {
                    verifyPermissions()
                    return
                }
            }
            startCore()
        }
    }

    companion object {
        private const val PERMISSIONS_RQ = 99
    }
}