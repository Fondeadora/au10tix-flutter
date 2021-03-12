package com.fondeadora.au10tix_flutter

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.widget.Toast
import androidx.core.os.bundleOf
import androidx.fragment.app.Fragment
import androidx.navigation.fragment.NavHostFragment
import com.au10tix.faceliveness.FaceLivenessResult
import com.au10tix.sdk.abstractions.FeatureManager
import com.au10tix.sdk.commons.Au10Error
import com.au10tix.sdk.core.Au10xCore
import com.au10tix.sdk.core.OnPrepareCallback
import com.au10tix.sdk.log.Logger
import com.au10tix.sdk.protocol.Au10Update
import com.au10tix.sdk.protocol.FeatureSessionError
import com.au10tix.sdk.protocol.FeatureSessionResult
import com.au10tix.sdk.ui.Au10UIManager
import com.au10tix.sdk.ui.UICallback
import com.au10tix.smartDocument.SmartDocumentFeatureManager
import com.au10tix.smartDocument.SmartDocumentResult
import com.fondeadora.au10tix_flutter.views.fragments.TITLE_KEY
import com.fondeadora.au10tix_flutter.views.fragments.TOKEN

class Au10tixMainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        if (savedInstanceState == null) {
            val bundle : Bundle = bundleOf(TOKEN to "", TITLE_KEY to "title")
            val host = NavHostFragment.create(R.navigation.nav_graph)
            host.arguments = bundle
            supportFragmentManager.beginTransaction().replace(R.id.homeFragment, host)
                    .setPrimaryNavigationFragment(host).commit()
        }
    }

}