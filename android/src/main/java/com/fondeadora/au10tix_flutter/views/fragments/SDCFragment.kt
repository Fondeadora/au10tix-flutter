package com.fondeadora.au10tix_flutter.views.fragments

import android.Manifest
import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import android.widget.TextView
import android.widget.Toast
import androidx.camera.core.CameraSelector
import androidx.navigation.fragment.NavHostFragment
import com.au10tix.sampleapp.views.ui.OverlayView
import com.au10tix.sdk.core.Au10xCore
import com.au10tix.sdk.core.comm.SessionCallback
import com.au10tix.sdk.protocol.Au10Update
import com.au10tix.sdk.protocol.FeatureSessionError
import com.au10tix.sdk.protocol.FeatureSessionResult
import com.au10tix.smartDocument.SmartDocumentFeatureManager
import com.au10tix.smartDocument.SmartDocumentFeatureSessionFrame
import com.fondeadora.au10tix_flutter.R
import java.io.File

// TODO: Rename parameter arguments, choose names that match
// the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
private const val ARG_PARAM1 = "param1"
private const val ARG_PARAM2 = "param2"

/**
 * A simple [Fragment] subclass.
 * Use the [SDCFragment.newInstance] factory method to
 * create an instance of this fragment.
 */
class SDCFragment : BaseFragment() {
    // TODO: Rename and change types of parameters
    override val requiredPermissions: Array<String?> = arrayOf(Manifest.permission.CAMERA,
            Manifest.permission.ACCESS_FINE_LOCATION,
            Manifest.permission.ACCESS_COARSE_LOCATION)
    private lateinit var coreManager: Au10xCore
    private lateinit var smartDocumentFeatureManager: SmartDocumentFeatureManager
    private lateinit var frameLayout: FrameLayout;
    private lateinit var details: TextView;

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?,
                              savedInstanceState: Bundle?): View? {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_s_d_c, container, false)
    }



    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        frameLayout = view.findViewById<FrameLayout>(R.id.passable_view_group)
        details = view.findViewById<TextView>(R.id.details)

        view.findViewById<OverlayView>(R.id.overlay).setFacing(CameraSelector.LENS_FACING_BACK)

        val title = requireArguments().getString(TITLE_KEY)
        (view.findViewById<View>(R.id.title) as TextView).text = title
        //instantiate a Smart Document Feature Manager
        smartDocumentFeatureManager = SmartDocumentFeatureManager(activity, this)
        //set it to auto to let the SDK decide when an image should be captured
        smartDocumentFeatureManager.isAuto = true
        smartDocumentFeatureManager.isSmart = true
        if (verifyPermissions()) {
            startCore()
        }
    }

    override fun startCore() {
        coreManager = Au10xCore.getInstance(requireContext().applicationContext)
        //Start the session by passing the feature manager, the view group, and a SessionCallback that will host the UI, to the prepared Au10xCore instance.
        coreManager.startSession(smartDocumentFeatureManager,
                frameLayout,
                object : SessionCallback {
                    override fun onSessionResult(sessionResult: FeatureSessionResult) {
                        //The session result contains the result image file, to be later forwarded to the back end.
                        var fileToSend: File = sessionResult.imageFile
                        //viewModel.setSmartDocumentResult((sessionResult as SmartDocumentResult))
                        NavHostFragment.findNavController(this@SDCFragment)
                                .navigateUp()
                    }

                    override fun onSessionError(sessionError: FeatureSessionError) {
                        Toast.makeText(context, sessionError.errorMessage, Toast.LENGTH_SHORT).show()
                        NavHostFragment.findNavController(this@SDCFragment)
                                .navigateUp()
                    }

                    override fun onSessionUpdate(captureFrameUpdate: Au10Update) {
                        //The Au10Update can now be cast to SmartDocumentFeatureSessionFrame. The results are accessed as follows:
                        details.visibility = View.VISIBLE
                        val frame = captureFrameUpdate as SmartDocumentFeatureSessionFrame
                        val sb = StringBuilder()
                                .append("blur: ").append(frame.blurScore).append("\n")
                                .append("dark: ").append(frame.darkScore).append("\n")
                                .append("reflection: ").append(frame.reflectionScore).append("\n")
                        details.text = sb.toString()
                    }
                })
    }

    override fun onDestroyView() {
        super.onDestroyView()
        coreManager.stopSession()
        smartDocumentFeatureManager.destroy()
    }


}