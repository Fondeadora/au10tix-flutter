package com.fondeadora.au10tix_flutter.views.fragments

import android.os.Bundle
import android.util.Log
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
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
import com.fondeadora.au10tix_flutter.R
import java.lang.IllegalStateException

// TODO: Rename parameter arguments, choose names that match
// the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
const val TITLE_KEY = "TITLE_KEY"
const val TOKEN = "TOKEN"
const val FLOW = "FLOW"
const val ID_TYPE = "ID_TYPE"


/**
 * A simple [Fragment] subclass.
 * Use the [HomeFragment.newInstance] factory method to
 * create an instance of this fragment.
 */
class HomeFragment : Fragment() {
    // TODO: Rename and change types of parameters
    private var title: String? = null
    private var token: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        arguments?.let {
            title = it.getString(TITLE_KEY)
            token = it.getString(TOKEN)
        }
    }

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?,
                              savedInstanceState: Bundle?): View? {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_home, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        prepareAu10tix(token);
    }
    private fun prepareAu10tix(token: String?) {
        if(token == null){
            throw  IllegalStateException("No token given")
        }
        Au10xCore.prepare(
                activity,
                token,
                object : OnPrepareCallback {
                    override fun onPrepareError(error: Au10Error) {
                        Log.d("prepare", "onPrepareError")
                        Toast.makeText(activity, "Session prepare failed", Toast.LENGTH_LONG)
                                .show()
                    }

                    override fun onPrepared(sessionId: String) {
                        //Only once Au10xCore is prepared it can perform detection sessions.
                        Log.d("prepare", "onPrepared")
                        Toast.makeText(activity, "Session prepared", Toast.LENGTH_LONG)
                                .show()
                        passportFlow(token)
                    }
                }
        )
    }

    private fun passportFlow(token: String) {
        val smartDocumentFeatureManager = SmartDocumentFeatureManager(context, this)
        smartDocumentFeatureManager.isAuto = true
        smartDocumentFeatureManager.isSmart = true
        handleSdkUI(smartDocumentFeatureManager);
    }

    lateinit var au10UIManager: Au10UIManager
    protected open fun handleSdkUI(featureManager: FeatureManager) {
        val nav = NavHostFragment.findNavController(this)
        //To use the default user interface, instantiate a FeatureManager, and pass it to the Au10UIManager as follows.

        val builder = Au10UIManager.Builder(activity, featureManager, object : UICallback() {
            //Set a UICallback to handle the received session results, errors, updates, and failures.

            override fun onSessionResult(sessionResult: FeatureSessionResult) {

                when (sessionResult) {
                    is FaceLivenessResult -> {
                    }
                    is SmartDocumentResult -> {
                        "Dark: " + sessionResult.darkScore + "\n" +
                                "Reflection: " + sessionResult.reflectionScore
                    }
                }
                nav.navigateUp()
                featureManager.destroy()
            }

            override fun onSessionError(sessionError: FeatureSessionError) {
                Toast.makeText(activity,
                        "SDK UI received error: " + sessionError.errorMessage,
                        Toast.LENGTH_SHORT).show()
                Logger.printLog("debug app error: " + sessionError.errorMessage)
                nav.navigateUp()
            }

            override fun onSessionUpdate(captureFrameUpdate: Au10Update) {}
            override fun onFail(result: FeatureSessionResult) {}
        })
        if (featureManager is SmartDocumentFeatureManager) {
            builder.setSecondaryTitle("Front Side")
        }
        //The UI provided along the SDK can be styled as follows:
        au10UIManager = builder.setStyle(R.style.custom_sdk_ui).build()
        val fragment: Fragment = au10UIManager.fragment
        if (fragment != null) {
            nav.navigate(R.id.action_homeFragment_to_SDCFragment, fragment.arguments)
        } else {
            Toast.makeText(activity, "Missing permissions", Toast.LENGTH_SHORT).show()
        }
    }
}