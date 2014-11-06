//
//  Sample.swift
//  ONES
//
//  Created by Solution on 14/10/9.
//  Copyright (c) 2014年 NNIT. All rights reserved.
//

import Foundation


enum SampleType: Int, Printable{
    case Medicine = 1, Appliance
    
    var description: String{
        return ["Medicine", "Appliance"][toRaw()-1]
    }
}
class Sample: Printable, Hashable{
    var sampleID: String
    var sampleName: String
    var sampleType: SampleType
    var samplePictureName: String
    
    var description: String{
        return "SampleID:\(sampleID), SampleName:\(sampleName), SampleType:\(sampleType), Sample Picture:\(samplePictureName)"
    }
    
    var hashValue: Int{
        return sampleID.hashValue
    }
    
    init(sampleID: String, sampleName: String, sampleType: SampleType, samplePictureName: String){
        self.sampleID = sampleID
        self.sampleName = sampleName
        self.sampleType = sampleType
        self.samplePictureName = samplePictureName
    }
    
    
    class func getSamples() -> [Sample]? {
        var result = Array<Sample>()
        result.append(Sample(sampleID: "SAMPLE-1", sampleName: "NovoRapid", sampleType: SampleType.Medicine, samplePictureName: "novorapid.png"))
        result.append(Sample(sampleID: "SAMPLE-2", sampleName: "Levemir", sampleType: SampleType.Medicine, samplePictureName: "levemir.png"))
        result.append(Sample(sampleID: "SAMPLE-3", sampleName: "NovoNorm", sampleType: SampleType.Medicine, samplePictureName: "novonorm.png"))
        result.append(Sample(sampleID: "SAMPLE-4", sampleName: "NovoPen", sampleType: SampleType.Appliance, samplePictureName: "novopen.png"))
        
        return result
    }
    
    class func getSample(sampleName: String) -> Sample?{
        if let samples = Sample.getSamples() {
            for sample in samples{
                if sample.sampleName == sampleName{
                    return sample
                }
            }
        }
        return nil
    }
    
}

func ==(lhs: Sample, rhs: Sample) -> Bool {
    return lhs.sampleID == rhs.sampleID
}
