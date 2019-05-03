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

#ifndef SPIKESCOPEDIALOG_H
#define SPIKESCOPEDIALOG_H

#include <QDialog>

using namespace std;

class QPushButton;
class QComboBox;
class QCheckBox;
class QSpinBox;
class SpikePlot;
class SignalProcessor;
class SignalSources;
class SignalChannel;
class QHBoxLayout;

class SpikeScopeDialog : public QDialog
{
    Q_OBJECT
public:
    explicit SpikeScopeDialog(SignalProcessor *inSignalProcessor, SignalSources *inSignalSources,
                              SignalChannel *initialChannel, SignalChannel *curDacChannel, QWidget *parent = 0, double fs = 30000.0);

    void updateWaveform(int numBlocks);
    void expandYScale();
    void contractYScale();

    // MM - UPDATE - WINDOW DISCRIMINATOR - 1/17/18
    bool detMode;
    int currentDACChannel;
    QVector<bool> wEnable;
    QVector<int> wStart;
    QVector<int> wStop;
    QVector<int> wType;
    QVector<int> wThresh;
    // END UPDATE

signals:
    // MM - UPDATE - 2019/01/20
    void selectedDACChannelIndexChanged(int index);
    void selectedDACChannelEnableChanged(bool enable);
    void selectedDACWindowStartChanged(int sample);
    void selectedDACWindowStopChanged(int sample);
    void selectedDACTriggerTypeChanged(int index);
    void selectedDACVoltageThresholdChanged(int threshold);
    void maxDACWindowStopChanged(int sample);
    void fsmModeChanged(bool fsmOn);
    void currentDACChannelEnableState(bool enable);
    // END

    // MM 2019/01/24
    void sampleRateChanged(double fs);
    void yScaleChanged(int yScaleValue);
    void yScaleIndexChanged(int index);
    void newSignalChannel(SignalChannel* channel);
    // END
    
public slots:    
    // MM - UPDATE - WINDOW DISCRIMINATOR - 2019-01-21
    void setCurrentDACChannel(int index);
    void setCurrentDACChannelEnable(bool enable);
    void setCurrentDACWindowStart(int sample);
    void setCurrentDACWindowStop(int sample);
    void setCurrentDACTriggerType(int index);
    void setCurrentDACVoltageThreshold(int threshold);
    void setCurrentDACWindowStartOffset(int maxWindowStop);
    void setDetectionMode(bool mode);
    void setVoltageThresholdDisplay(int value);
    // END UPDATE

    void setNewChannel(SignalChannel* newChannel);
    void setYScale(int index);
    void setSampleRate(double newSampleRate);

private slots:
    void changeYScale(int index);
    void enableCorrectUIgraphics(int index);
    void resetThresholdToZero();
    void setNumSpikes(int index);
    void clearScope();
    void setDigitalInput(int index);
    void setEdgePolarity(int index);
    void applyToAll();

    // MM - UPDATE - 2019-01-21
    void changeDACChannelFromSpikeDialog(int channel);
    void changeDACVoltageThresholdFromSpikeDialog(int threshold);
    void changeDACTriggerTypeFromSpikeDialog(int index);
    void changeDACWindowStopFromSpikeDialog(int sample);
    void changeDACWindowStartFromSpikeDialog(int sample);
    void changeDACEnableFromSpikeDialog(bool enable);
    // END

private:
    SpikePlot* initializeSpikePlot();
    QHBoxLayout* initializeVoltDigDetectionUI();
    QHBoxLayout* initializeWindowDetectionUI();
    QComboBox* initializeDigComboBox();
    void initWindowProperties();
    void initializeMainLayout(QHBoxLayout* thresholdSpinBoxLayout,
                              QHBoxLayout* windowDetectorLayout);

    void enableVoltageTriggerUI(bool voltOn);
    void enableDigitalTriggerUI(bool digOn);
    void enableWindowTriggerUI(bool fsmOn);

    QVector<int> yScaleList;

    SignalProcessor *signalProcessor;
    SignalSources *signalSources;
    SignalChannel *currentChannel;
    SignalChannel *selectedDacChannel;

    QPushButton *resetToZeroButton;
    QPushButton *clearScopeButton;
    QPushButton *applyToAllButton;

    // MM - UPDATE - WINDOW DISCRIMINATOR - 1/17/18
    QCheckBox *enableDacChannelCheckBox;
    QComboBox *selectDacChannelComboBox;
    QSpinBox *startWindowSpinBox;
    QSpinBox *stopWindowSpinBox;
    QComboBox *setWindowTypeComboBox;
    QSpinBox *setWindowThresholdSpinBox;
    // END UPDATE

    QComboBox *triggerTypeComboBox;
    QComboBox *numSpikesComboBox;
    QComboBox *digitalInputComboBox;
    QComboBox *edgePolarityComboBox;
    QComboBox *yScaleComboBox;

    QSpinBox *thresholdSpinBox;
    SpikePlot *spikePlot = nullptr;

    double sampleRate;
};

#endif // SPIKESCOPEDIALOG_H
