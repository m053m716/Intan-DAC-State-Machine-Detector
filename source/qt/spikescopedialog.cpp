//  ------------------------------------------------------------------------
//
//  This file is part of the Intan Technologies RHS2000 Interface
//  Version 1.01
//  Copyright (C) 2013-2017 Intan Technologies
//
//  ------------------------------------------------------------------------
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Lesser General Public License as published
//  by the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Lesser General Public License for more details.
//
//  You should have received a copy of the GNU Lesser General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.

#include <QtGui>
#if QT_VERSION >= QT_VERSION_CHECK(5,0,0)
#include <QtWidgets>
#endif
#include <iostream>

#include "globalconstants.h"
#include "spikescopedialog.h"
#include "signalchannel.h"
#include "signalgroup.h"
#include "spikeplot.h"

// Spike scope dialog.
// This dialog allows users to view 3-msec snippets of neural spikes triggered
// either from a selectable voltage threshold or a digital input threshold.  Multiple
// spikes are superimposed on the display so that users can compare spike shapes.

SpikeScopeDialog::SpikeScopeDialog(SignalProcessor *inSignalProcessor, SignalSources *inSignalSources,
                                   SignalChannel *initialChannel, SignalChannel *curDacChannel, QWidget *parent, double fs) :
    QDialog(parent)
{
    // Set all the passed variables for this class
    signalProcessor = inSignalProcessor;
    signalSources = inSignalSources;
    currentChannel = initialChannel;
    selectedDacChannel = curDacChannel;
    currentDACChannel = selectedDacChannel->chipChannel;

    // Initialize all window properties associated with class
    initWindowProperties();
    setSampleRate(fs);

    // Initialize the spikePlot for displaying detected spikes
    spikePlot = initializeSpikePlot();

    // Initialize UI layouts
    setFont(QFont("Arial", 18));
    QHBoxLayout* thresholdSpinBoxLayout = initializeVoltDigDetectionUI();
    QHBoxLayout* windowDetectorLayout = initializeWindowDetectionUI();
    initializeMainLayout(thresholdSpinBoxLayout,windowDetectorLayout);

    enableCorrectUIgraphics(triggerTypeComboBox->currentIndex());
    setNumSpikes(numSpikesComboBox->currentIndex());
    setDigitalInput(digitalInputComboBox->currentIndex());
    setEdgePolarity(edgePolarityComboBox->currentIndex());
}

void SpikeScopeDialog::changeYScale(int index)
{
    emit(yScaleIndexChanged(index));
    emit(yScaleChanged(yScaleList[index]));
}

void SpikeScopeDialog::setYScale(int index)
{
    yScaleComboBox->setCurrentIndex(index);
    emit(yScaleChanged(yScaleList[index]));
}

void SpikeScopeDialog::setSampleRate(double newSampleRate)
{
    sampleRate = newSampleRate;
    emit(sampleRateChanged(sampleRate));
}

// Select a voltage trigger if index == 0.
// Select a digital input trigger if index == 1.
void SpikeScopeDialog::enableCorrectUIgraphics(int index)
{
    bool voltageTriggerMode = (index == 0) && (!detMode);
    bool digitalTriggerMode = (index == 1) && (!detMode);

    enableVoltageTriggerUI(voltageTriggerMode);
    enableDigitalTriggerUI(digitalTriggerMode);
    enableWindowTriggerUI(detMode);
}

void SpikeScopeDialog::enableVoltageTriggerUI(bool voltOn)
{
    thresholdSpinBox->setEnabled(voltOn);
    resetToZeroButton->setEnabled(voltOn);
    spikePlot->setVoltageTriggerMode(voltOn);
}

void SpikeScopeDialog::enableDigitalTriggerUI(bool digOn)
{
    digitalInputComboBox->setEnabled(digOn);
    edgePolarityComboBox->setEnabled(digOn);
}

void SpikeScopeDialog::enableWindowTriggerUI(bool fsmOn)
{
    enableDacChannelCheckBox->setEnabled(fsmOn);
    selectDacChannelComboBox->setEnabled(fsmOn);
    startWindowSpinBox->setEnabled(fsmOn);
    stopWindowSpinBox->setEnabled(fsmOn);
    setWindowTypeComboBox->setEnabled(fsmOn);
    setWindowThresholdSpinBox->setEnabled(fsmOn);
}

void SpikeScopeDialog::resetThresholdToZero()
{
    thresholdSpinBox->setValue(0);
}

void SpikeScopeDialog::updateWaveform(int numBlocks)
{
    spikePlot->updateWaveform(numBlocks);
}

void SpikeScopeDialog::clearScope()
{
    spikePlot->clearScope();
}


// Set number of spikes plotted superimposed.
void SpikeScopeDialog::setNumSpikes(int index)
{
    int num;

    switch (index) {
        case 0: num = 10; break;
        case 1: num = 20; break;
//        case 2: num = 30; break;
    }

    spikePlot->setMaxNumSpikeWaveforms(num);
}

void SpikeScopeDialog::setDigitalInput(int index)
{
    spikePlot->setDigitalTriggerChannel(index);
}

void SpikeScopeDialog::setVoltageThresholdDisplay(int value)
{
    if (detMode) {
        setWindowThresholdSpinBox->setValue(value);
    } else {
        int curValue = thresholdSpinBox->value();
        thresholdSpinBox->setValue(value);
        if (curValue != value){
            emit(thresholdSpinBox->valueChanged(value));
        }
    }

}

void SpikeScopeDialog::setEdgePolarity(int index)
{
    spikePlot->setDigitalEdgePolarity(index == 0);
}

// Set Spike Scope to a new signal channel source.
void SpikeScopeDialog::setNewChannel(SignalChannel* newChannel)
{
    currentChannel = newChannel;
    emit(newSignalChannel(newChannel));

    if (newChannel->voltageTriggerMode) {
        triggerTypeComboBox->setCurrentIndex(0);
    } else {
        triggerTypeComboBox->setCurrentIndex(1);
    }

    if (!detMode) {
        thresholdSpinBox->setValue(newChannel->voltageThreshold);
        digitalInputComboBox->setCurrentIndex(newChannel->digitalTriggerChannel);
        if (newChannel->digitalEdgePolarity) {
            edgePolarityComboBox->setCurrentIndex(0);
        } else {
            edgePolarityComboBox->setCurrentIndex(1);
        }
    }
}

void SpikeScopeDialog::expandYScale()
{
    if (yScaleComboBox->currentIndex() > 0) {
        yScaleComboBox->setCurrentIndex(yScaleComboBox->currentIndex() - 1);
        changeYScale(yScaleComboBox->currentIndex());
    }
}

void SpikeScopeDialog::contractYScale()
{
    if (yScaleComboBox->currentIndex() < yScaleList.size() - 1) {
        yScaleComboBox->setCurrentIndex(yScaleComboBox->currentIndex() + 1);
        changeYScale(yScaleComboBox->currentIndex());
    }
}
// Apply trigger settings to all channels on selected port.
void SpikeScopeDialog::applyToAll()
{
    QMessageBox::StandardButton r;
    r = QMessageBox::question(this, tr("Trigger Settings"),
                                 tr("Do you really want to copy the current channel's trigger "
                                    "settings to <b>all</b> amplifier channels on this port?"),
                                 QMessageBox::Yes | QMessageBox::No);
    if (r == QMessageBox::Yes) {
        for (int i = 0; i < currentChannel->signalGroup->numChannels(); ++i) {
            currentChannel->signalGroup->channel[i].voltageTriggerMode = currentChannel->voltageTriggerMode;
            currentChannel->signalGroup->channel[i].voltageThreshold = currentChannel->voltageThreshold;
            currentChannel->signalGroup->channel[i].digitalTriggerChannel = currentChannel->digitalTriggerChannel;
            currentChannel->signalGroup->channel[i].digitalEdgePolarity = currentChannel->digitalEdgePolarity;
        }
    }
}

// CHANGE SLOTS -> CHANGED IN SPIKE DIALOG //
// Change whether the threshold actually is implemented in the FSM
void SpikeScopeDialog::changeDACEnableFromSpikeDialog(bool enable)
{
    wEnable[currentDACChannel] = enable;
    emit selectedDACChannelEnableChanged(enable);
}
// Change the window start (for current channel) from this dialog
void SpikeScopeDialog::changeDACWindowStartFromSpikeDialog(int sample)
{
    // check for valid sample index value
    if (sample < 0 || sample > 1000) {
        cerr << "Error in SpikeScopeDialog::setDACWindowStart: sample (" << sample << ") out of range." << endl;
        return;
    }

    wStart[currentDACChannel] = sample;
    emit selectedDACWindowStartChanged(sample);
}
// Change the window stop (for current channel) from this dialog
void SpikeScopeDialog::changeDACWindowStopFromSpikeDialog(int sample)
{
    // check for valid sample index value
    if (sample < 0 || sample > 1000) {
        cerr << "Error in SpikeScopeDialog::setDACWindowStop: sample (" << sample << ") out of range." << endl;
        return;
    }

    wStop[currentDACChannel] = sample;
    emit selectedDACWindowStopChanged(sample);
}
// Change the window type (include vs exclude) from this dialog
void SpikeScopeDialog::changeDACTriggerTypeFromSpikeDialog(int index)
{
    // check for valid trigger type value
    if (index < 0 || index > 1) {
        cerr << "Error in SpikeScopeDialog::changeDACTriggerTypeFromSpikeDialog: index (" << index << ") out of range." << endl;
        return;
    }

    wType[currentDACChannel] = index;
    emit selectedDACTriggerTypeChanged(index);
}
// Change the window threshold value from this dialog
void SpikeScopeDialog::changeDACVoltageThresholdFromSpikeDialog(int threshold)
{
    // check that threshold is in range
    if (threshold < -5000 || threshold > 5000) {
        cerr << "Error in SpikeScopeDialog::changeDACVoltageThresholdFromSpikeDialog: threshold (" << threshold << ") out of range." << endl;
        return;
    }

    wThresh[currentDACChannel] = threshold;
    emit selectedDACVoltageThresholdChanged(threshold);
}
// Change the current DAC channel under consideration by this dialog
void SpikeScopeDialog::changeDACChannelFromSpikeDialog(int channel)
{
    // make sure it's a valid channel index
    if (channel < 0 || channel > 7) {
        cerr << "Error in SpikeScopeDialog::changeDACChannelFromSpikeDialog: channel (" << channel << ") out of range." << endl;
        return;
    }

    // Update channel info and notify about it
    currentDACChannel = channel;
    emit(selectedDACChannelIndexChanged(channel));

    // Update channel enable info check box.
    setCurrentDACChannelEnable(wEnable[channel]);

    // Update channel start/stop spin boxes and threshold
    setCurrentDACWindowStart(wStart[channel]);
    setCurrentDACWindowStop(wStop[channel]);

    // Update channel type
    setCurrentDACTriggerType(wType[channel]);

    // Update voltage threshold
    setCurrentDACVoltageThreshold(wThresh[channel]);

}

// SET FUNCTIONS -> FOR EXTERNAL SETTERS //

// Change the detection settings
void SpikeScopeDialog::setDetectionMode(bool mode)
{
    detMode = mode;
    enableCorrectUIgraphics(triggerTypeComboBox->currentIndex());
    triggerTypeComboBox->setEnabled(!mode);
    applyToAllButton->setEnabled(!mode);

    // mode == true -> FSM (window) discriminator
    if (mode) {
        setWindowTitle(tr("Window Scope"));
    } else {
        setWindowTitle(tr("Spike Scope"));
    }

    emit(fsmModeChanged(mode));
}
// Set window offset for DAC
void SpikeScopeDialog::setCurrentDACWindowStartOffset(int maxWindowStop)
{
    if (maxWindowStop < 0 || maxWindowStop > 1000) {
        cerr << "Error in SpikeScopeDialog::setCurrentDACWindowStartOffset: maxWindowStop (" << maxWindowStop << ") out of range." << endl;
        return;
    }

    emit(maxDACWindowStopChanged(maxWindowStop));
}
// Set enable from outside the dialog
void SpikeScopeDialog::setCurrentDACChannelEnable(bool enable)
{
    enableDacChannelCheckBox->setChecked(enable);
    emit(currentDACChannelEnableState(enable));
}
// Set DAC channel for combo box from outside the dialog
void SpikeScopeDialog::setCurrentDACChannel(int index)
{
    if (index < 0 || index > 7) {
        cerr << "Error in SpikeScopeDialog::setCurrentDACChannel: index (" << index << ") out of range." << endl;
        return;
    }
    if (index != currentDACChannel){
        selectDacChannelComboBox->setCurrentIndex(index);
        emit(selectedDACChannelIndexChanged(index));
    } else {
        selectDacChannelComboBox->setCurrentIndex(index);
    }

}
// Set DAC window start from outside the dialog
void SpikeScopeDialog::setCurrentDACWindowStart(int sample)
{
    if (sample < 0 || sample > 1000) {
        cerr << "Error in SpikeScopeDialog::setCurrentDACWindowStart: sample (" << sample << ") out of range." << endl;
        return;
    }
    startWindowSpinBox->setValue(sample);
}
// Update the DAC window stop sample from outside the dialog
void SpikeScopeDialog::setCurrentDACWindowStop(int sample)
{
    if (sample < 0 || sample > 1000) {
        cerr << "Error in SpikeScopeDialog::setCurrentDACWindowStop: sample (" << sample << ") out of range." << endl;
        return;
    }
    stopWindowSpinBox->setValue(sample);
}
// Update the DAC-FSM trigger type (include vs. exclude) from outside the dialog
void SpikeScopeDialog::setCurrentDACTriggerType(int index)
{
    if (index < 0 || index > 1) {
        cerr << "Error in SpikeScopeDialog::setCurrentDACTriggerType: index (" << index << ") out of range." << endl;
        return;
    }
    setWindowTypeComboBox->setCurrentIndex(index);
}
// Update the DAC-FSM trigger voltage from outside the dialog
void SpikeScopeDialog::setCurrentDACVoltageThreshold(int threshold)
{
    if (threshold < -5000 || threshold > 5000) {
        cerr << "Error in SpikeScopeDialog::setCurrentDACVoltageThreshold: threshold (" << threshold << ") out of range." << endl;
        return;
    }
    setWindowThresholdSpinBox->setValue(threshold);
}

// INITIALIZE FUNCTIONS -> SO THEY CAN BE COLLAPSED... //

// initialize Spike Plot and its connections
SpikePlot* SpikeScopeDialog::initializeSpikePlot()
{
    SpikePlot *s = new SpikePlot(signalProcessor, currentChannel, selectedDacChannel, this, this, sampleRate);
    // spikescope --> spikePlot
    connect(this,SIGNAL(selectedDACChannelIndexChanged(int)),
            s,SLOT(setCurrentChannel(int)));
    connect(this,SIGNAL(selectedDACWindowStartChanged(int)),
            s,SLOT(setWStart(int)));
    connect(this,SIGNAL(selectedDACWindowStopChanged(int)),
            s,SLOT(setWStop(int)));
    connect(this,SIGNAL(maxDACWindowStopChanged(int)),
            s,SLOT(setWMax(int)));
    connect(this,SIGNAL(selectedDACVoltageThresholdChanged(int)),
            s,SLOT(setWThresh(int)));
    connect(this,SIGNAL(fsmModeChanged(bool)),
            s,SLOT(setWMode(bool)));
    connect(this,SIGNAL(selectedDACTriggerTypeChanged(int)),
            s,SLOT(setWType(int)));

    connect(this, SIGNAL(selectedDACChannelEnableChanged(bool)),
            s,SLOT(setWEnable(bool)));
    connect(this, SIGNAL(currentDACChannelEnableState(bool)),
            s, SLOT(setWEnable(bool)));

    connect(this, SIGNAL(sampleRateChanged(double)),
            s,SLOT(setSampleRate(double)));
    connect(this, SIGNAL(yScaleChanged(int)),
            s, SLOT(setYScale(int)));
    connect(this, SIGNAL(newSignalChannel(SignalChannel*)),
            s, SLOT(setNewChannel(SignalChannel*)));

    // spikePlot -> spikescope
    connect(s,SIGNAL(currentVoltageThresholdChanged(int)),
            this, SLOT(setVoltageThresholdDisplay(int)));
    connect(s,SIGNAL(windowTypeChanged(int)),
            this,SLOT(setCurrentDACTriggerType(int)));

    return s;
}
// Get the voltage/digital threshold detector layout part
QHBoxLayout* SpikeScopeDialog::initializeVoltDigDetectionUI()
{
    resetToZeroButton = new QPushButton(tr("Zero"));
    clearScopeButton = new QPushButton(tr("Clear Scope"));
    applyToAllButton = new QPushButton(tr("Apply to Entire Port"));

    connect(resetToZeroButton, SIGNAL(clicked()),
            this, SLOT(resetThresholdToZero()));
    connect(clearScopeButton, SIGNAL(clicked()),
            this, SLOT(clearScope()));
    connect(applyToAllButton, SIGNAL(clicked()),
            this, SLOT(applyToAll()));

    triggerTypeComboBox = new QComboBox();
    triggerTypeComboBox->addItem(tr("Voltage Threshold"));
    triggerTypeComboBox->addItem(tr("Digital Input"));
    triggerTypeComboBox->setCurrentIndex(0);
    triggerTypeComboBox->setEnabled(true);

    connect(triggerTypeComboBox, SIGNAL(currentIndexChanged(int)),
            this, SLOT(enableCorrectUIgraphics(int)));

    thresholdSpinBox = new QSpinBox();
    thresholdSpinBox->setRange(-5000, 5000);
    thresholdSpinBox->setSingleStep(5);
    thresholdSpinBox->setValue(0);

    connect(thresholdSpinBox, SIGNAL(valueChanged(int)),
            this, SLOT(changeDACVoltageThresholdFromSpikeDialog(int)));

    QHBoxLayout *origSpinBoxLayout = new QHBoxLayout;
    origSpinBoxLayout ->addWidget(resetToZeroButton);
    origSpinBoxLayout ->addWidget(thresholdSpinBox);
    origSpinBoxLayout ->addWidget(new QLabel(QSTRING_MU_SYMBOL + "V"));

    return origSpinBoxLayout ;
}
// Get the window detector layout part
QHBoxLayout *SpikeScopeDialog::initializeWindowDetectionUI()
{
    enableDacChannelCheckBox = new QCheckBox();
    enableDacChannelCheckBox->setChecked(false);

    connect(enableDacChannelCheckBox, SIGNAL(toggled(bool)),
                this, SLOT(changeDACEnableFromSpikeDialog(bool)));

    selectDacChannelComboBox = new QComboBox();
    selectDacChannelComboBox->addItem(tr("DAC-1"));
    selectDacChannelComboBox->addItem(tr("DAC-2"));
    selectDacChannelComboBox->addItem(tr("DAC-3"));
    selectDacChannelComboBox->addItem(tr("DAC-4"));
    selectDacChannelComboBox->addItem(tr("DAC-5"));
    selectDacChannelComboBox->addItem(tr("DAC-6"));
    selectDacChannelComboBox->addItem(tr("DAC-7"));
    selectDacChannelComboBox->addItem(tr("DAC-8"));
    selectDacChannelComboBox->setCurrentIndex(0);

    connect(selectDacChannelComboBox, SIGNAL(currentIndexChanged(int)),
                this, SLOT(changeDACChannelFromSpikeDialog(int)));

    startWindowSpinBox = new QSpinBox();
    startWindowSpinBox->setRange(0x0000,0x003c);
    startWindowSpinBox->setSingleStep(1);
    startWindowSpinBox->setValue(0);

    connect(startWindowSpinBox, SIGNAL(valueChanged(int)),
                this, SLOT(changeDACWindowStartFromSpikeDialog(int)));

    stopWindowSpinBox = new QSpinBox();
    stopWindowSpinBox->setRange(0x0000,0x003c);
    stopWindowSpinBox->setSingleStep(1);
    stopWindowSpinBox->setValue(0);

    connect(stopWindowSpinBox, SIGNAL(valueChanged(int)),
                this, SLOT(changeDACWindowStopFromSpikeDialog(int)));

    setWindowTypeComboBox = new QComboBox();
    setWindowTypeComboBox->addItem(tr("Include"));
    setWindowTypeComboBox->addItem(tr("Exclude"));
    setWindowTypeComboBox->setCurrentIndex(0);

    connect(setWindowTypeComboBox, SIGNAL(currentIndexChanged(int)),
                this, SLOT(changeDACTriggerTypeFromSpikeDialog(int)));

    setWindowThresholdSpinBox = new QSpinBox();
    setWindowThresholdSpinBox->setRange(-5000, 5000);
    setWindowThresholdSpinBox->setSingleStep(5);
    setWindowThresholdSpinBox->setValue(0);

    connect(setWindowThresholdSpinBox, SIGNAL(valueChanged(int)),
                this, SLOT(changeDACVoltageThresholdFromSpikeDialog(int)));

    QHBoxLayout *w = new QHBoxLayout;
    w->addWidget(enableDacChannelCheckBox);
    w->addWidget(selectDacChannelComboBox);
    w->addSpacing(15);
    w->addWidget(startWindowSpinBox);
    w->addSpacing(5);
    w->addWidget(stopWindowSpinBox);
    w->addSpacing(30);
    w->addWidget(setWindowTypeComboBox);
    w->addWidget(setWindowThresholdSpinBox);
    return w;
}
// Enumerate list for digital combo box
QComboBox *SpikeScopeDialog::initializeDigComboBox()
{
    QComboBox* cb = new QComboBox();
    cb->addItem(tr("DIGITAL IN 1"));
    cb->addItem(tr("DIGITAL IN 2"));
    cb->addItem(tr("DIGITAL IN 3"));
    cb->addItem(tr("DIGITAL IN 4"));
    cb->addItem(tr("DIGITAL IN 5"));
    cb->addItem(tr("DIGITAL IN 6"));
    cb->addItem(tr("DIGITAL IN 7"));
    cb->addItem(tr("DIGITAL IN 8"));
    cb->addItem(tr("DIGITAL IN 9"));
    cb->addItem(tr("DIGITAL IN 10"));
    cb->addItem(tr("DIGITAL IN 11"));
    cb->addItem(tr("DIGITAL IN 12"));
    cb->addItem(tr("DIGITAL IN 13"));
    cb->addItem(tr("DIGITAL IN 14"));
    cb->addItem(tr("DIGITAL IN 15"));
    cb->addItem(tr("DIGITAL IN 16"));
    cb->setCurrentIndex(0);
    connect(cb, SIGNAL(currentIndexChanged(int)),
            this, SLOT(setDigitalInput(int)));
    return cb;
}
// Set properties for window elements
void SpikeScopeDialog::initWindowProperties()
{
    detMode = false;        // false -> FSM is off
    wEnable.resize(8);      // enable -> FSM threshold in use?
    wEnable.fill(false);
    wStart.resize(8);       // start sample
    wStart.fill(0);
    wStop.resize(8);        // stop sample
    wStop.fill(0);
    wType.resize(8);        // include or exclude?
    wType[0] = 0;
    wType[1] = 1;
    wType[2] = 0;
    wType[3] = 1;
    wType[4] = 0;
    wType[5] = 1;
    wType[6] = 0;
    wType[7] = 1;
    wThresh.resize(8);      // voltage threshold for each window
    wThresh.fill(0);
}
// Initializes the full layout
void SpikeScopeDialog::initializeMainLayout(QHBoxLayout *thresholdSpinBoxLayout, QHBoxLayout *windowDetectorLayout)
{
    // Initialize UI widgets
    digitalInputComboBox = initializeDigComboBox();

    edgePolarityComboBox = new QComboBox();
    edgePolarityComboBox->addItem(tr("Rising Edge"));
    edgePolarityComboBox->addItem(tr("Falling Edge"));
    edgePolarityComboBox->setCurrentIndex(0);
    connect(edgePolarityComboBox, SIGNAL(currentIndexChanged(int)),
            this, SLOT(setEdgePolarity(int)));

    numSpikesComboBox = new QComboBox();
    numSpikesComboBox->addItem(tr("Show 10 Spikes"));
    numSpikesComboBox->addItem(tr("Show 20 Spikes"));
//    numSpikesComboBox->addItem(tr("Show 30 Spikes"));
    numSpikesComboBox->setCurrentIndex(1);
    connect(numSpikesComboBox, SIGNAL(currentIndexChanged(int)),
            this, SLOT(setNumSpikes(int)));

    yScaleList.append(50);
    yScaleList.append(100);
    yScaleList.append(200);
    yScaleList.append(500);
    yScaleList.append(1000);
    yScaleList.append(2000);
    yScaleList.append(5000);
    yScaleComboBox = new QComboBox();
    for (int i = 0; i < yScaleList.size(); ++i) {
        yScaleComboBox->addItem("+/-" + QString::number(yScaleList[i]) +
                                " " + QSTRING_MU_SYMBOL + "V");
    }
    yScaleComboBox->setCurrentIndex(4);
    connect(yScaleComboBox, SIGNAL(currentIndexChanged(int)),
            this, SLOT(changeYScale(int)));

    QHBoxLayout *windowLabelLayout = new QHBoxLayout;
    windowLabelLayout -> addStretch(1);
    windowLabelLayout -> addWidget(new QLabel(tr("Channel")));
    windowLabelLayout -> addStretch(1);
    windowLabelLayout -> addWidget(new QLabel(tr("Start")));
    windowLabelLayout -> addStretch(1);
    windowLabelLayout -> addWidget(new QLabel(tr("Stop")));
    windowLabelLayout -> addSpacing(5);
    windowLabelLayout -> addStretch(2);
    windowLabelLayout -> addWidget(new QLabel(tr("Type")));
    windowLabelLayout -> addStretch(2);
    windowLabelLayout -> addWidget(new QLabel(QSTRING_MU_SYMBOL + "V"));
    windowLabelLayout -> addStretch(1);
    windowLabelLayout -> addSpacing(5);

    QVBoxLayout *triggerLayout = new QVBoxLayout;
    triggerLayout->addWidget(new QLabel(tr("Type:")));
    triggerLayout->addWidget(triggerTypeComboBox);
    triggerLayout->addStretch(1);
    triggerLayout->addWidget(new QLabel(tr("Voltage Threshold:")));
    triggerLayout->addLayout(thresholdSpinBoxLayout);
    triggerLayout->addStretch(3);
    triggerLayout->addWidget(new QLabel(tr("Digital Source:")));
    triggerLayout->addWidget(digitalInputComboBox);
    triggerLayout->addWidget(edgePolarityComboBox);
    triggerLayout->addStretch(3);
    triggerLayout->addWidget(new QLabel(tr("Window Discriminator:")));
    triggerLayout->addLayout(windowLabelLayout);
    triggerLayout->addLayout(windowDetectorLayout);

    QVBoxLayout *displayLayout = new QVBoxLayout;
    displayLayout->addWidget(new QLabel(tr("Voltage Scale:")));
    displayLayout->addWidget(yScaleComboBox);
    displayLayout->addWidget(numSpikesComboBox);
    displayLayout->addWidget(clearScopeButton);

    QGroupBox *triggerGroupBox = new QGroupBox(tr("Trigger Settings"));
    triggerGroupBox->setLayout(triggerLayout);

    QGroupBox *displayGroupBox = new QGroupBox(tr("Display Settings"));
    displayGroupBox->setLayout(displayLayout);

    QVBoxLayout *leftLayout = new QVBoxLayout;
    leftLayout->addWidget(triggerGroupBox);
    leftLayout->addWidget(applyToAllButton);
    leftLayout->addStretch(1);
    leftLayout->addWidget(displayGroupBox);
    leftLayout->setStretch(0,2);
    leftLayout->setStretch(1,0);
    leftLayout->setStretch(2,0);

    QHBoxLayout *mainLayout = new QHBoxLayout;
    mainLayout->addLayout(leftLayout);
    mainLayout->addWidget(spikePlot);
    mainLayout->setStretch(0, 0);
    mainLayout->setStretch(1, 2);

    setLayout(mainLayout);
}
