package com.au10tix.sampleapp.models

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.au10tix.faceliveness.FaceLivenessResult
import com.au10tix.smartDocument.SmartDocumentResult

class DataViewModel : ViewModel() {

    val sdcFrontResult = MutableLiveData<SmartDocumentResult>()
    val pflResult = MutableLiveData<FaceLivenessResult>()
    var sessionId: String? = null

    fun setFaceLivenessResult(pflSessionResult: FaceLivenessResult) {
        pflResult.postValue(pflSessionResult)
    }

    fun setSmartDocumentResult(sessionResult: SmartDocumentResult) {
        sdcFrontResult.postValue(sessionResult)
    }

}